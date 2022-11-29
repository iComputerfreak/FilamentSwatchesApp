//
//  NFCWriter.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 10.11.22.
//

import Foundation
import CoreNFC

enum NFCWriterError: Error {
    case writingUnavailable
    case invalidBaseURL
    case invalidURL
    case noMessage
    case newSessionWhileOldOpen
}

enum URLKeys {
    static let material = "material"
    static let brand = "brand"
    static let colorName = "color"
    static let extruderTemp = "extruder_temp"
    static let bedTemp = "bed_temp"
    static let productLine = "product_line"
    static let colorCode = "color_code"
}


class NFCWriter: NSObject, NFCNDEFReaderSessionDelegate {
    private var session: NFCNDEFReaderSession?
    private var continuation: CheckedContinuation<Bool, Error>?
    private var message: NFCNDEFMessage?
    var baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("Reader session active")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Reader session invalidated")
        continuation?.resume(throwing: error)
        continuation = nil
        
        if self.session == session {
            self.session = nil
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("Detected \(messages.count) messages")
    }
    
    func writeSwatch(_ swatch: Swatch) async throws -> Bool {
        print("Writing Swatch...")
        guard NFCNDEFReaderSession.readingAvailable else {
            throw NFCWriterError.writingUnavailable
        }
        
        // There should not be an existing session already in progress
        guard session == nil && continuation == nil else {
            print("Session already in progress")
            throw NFCWriterError.newSessionWhileOldOpen
        }
                
        // Construct the URL
        guard var components = URLComponents(string: baseURL) else {
            throw NFCWriterError.invalidBaseURL
        }
        if components.queryItems == nil {
            components.queryItems = []
        }
        // Append the url parameters
        components.queryItems?.append(contentsOf: [
            .init(name: URLKeys.material, value: swatch.material),
            .init(name: URLKeys.brand, value: swatch.brand),
            .init(name: URLKeys.colorName, value: swatch.colorName),
        ])
        
        if swatch.extruderTemp > 0 {
            components.queryItems?.append(.init(name: URLKeys.extruderTemp, value: String(swatch.extruderTemp)))
        }
        if swatch.bedTemp > 0 {
            components.queryItems?.append(.init(name: URLKeys.bedTemp, value: String(swatch.bedTemp)))
        }
        if !swatch.productLine.isEmpty {
            components.queryItems?.append(.init(name: URLKeys.productLine, value: swatch.productLine))
        }
        if let color = swatch.color {
            components.queryItems?.append(.init(name: URLKeys.colorCode, value: color.hexCode))
        }
        
        guard let url = components.url else {
            throw NFCWriterError.invalidURL
        }
        
        guard let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            throw NFCWriterError.invalidURL
        }
        
        // Create NDEF message and NFC session
        self.message = NFCNDEFMessage(records: [payload])
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            session?.begin()
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        print("Detected \(tags.count) tags")
        // If we have no data to write, we can abort the whole writer
        guard let message = message else {
            continuation?.resume(throwing: NFCWriterError.noMessage)
            continuation = nil
            session.invalidate()
            return
        }
        
        // Do not write multiple tags
        guard tags.count <= 1 else {
            // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and write an NDEF message to it.
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if error != nil {
                session.alertMessage = "Unable to connect to tag."
                self.continuation?.resume(returning: false)
                self.continuation = nil
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                guard error == nil else {
                    session.alertMessage = "Unable to query the NDEF status of tag."
                    self.continuation?.resume(returning: false)
                    self.continuation = nil
                    session.invalidate()
                    return
                }
                
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                case .readWrite:
                    tag.writeNDEF(message, completionHandler: { (error: Error?) in
                        if error != nil {
                            session.alertMessage = "Write NDEF message fail: \(error!)"
                        } else {
                            session.alertMessage = "Write successful!"
                            self.continuation?.resume(returning: true)
                            self.continuation = nil
                            session.invalidate()
                            return
                        }
                    })
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                }
                
                // Do not return the error, as it is already displayed on the scanning sheet
                self.continuation?.resume(returning: false)
                self.continuation = nil
                session.invalidate()
            })
        })
    }
}
