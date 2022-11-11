//
//  NFCReader.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 08.11.22.
//

import Foundation
import CoreNFC

enum NFCReaderError: Error {
    case readingUnavailable
    case noQueryItemsRead
    case queryItemsMissing
    case newSessionWhileOldOpen
}

class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    private var continuation: CheckedContinuation<Swatch?, Error>?
    private var session: NFCNDEFReaderSession?
    
    func scanForSwatch() async throws -> Swatch? {
        print("Scanning for swatch")
        guard NFCNDEFReaderSession.readingAvailable else {
            throw NFCReaderError.readingUnavailable
        }
        
        // There should not be an existing session already in progress
        guard session == nil && continuation == nil else {
            print("Session already in progress")
            throw NFCReaderError.newSessionWhileOldOpen
        }
        
        // Read NFC Data
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        
        return try await withCheckedThrowingContinuation({ continuation in
            self.continuation = continuation
            session?.begin()
        })
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("Reader session active")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Reader session invalidated")
        continuation?.resume(throwing: error)
        continuation = nil
        // Delete the invalidated session
        if self.session == session {
            self.session = nil
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("Detected \(messages.count) messages")
    }
    
    func decodeSwatch(from url: URL) throws -> Swatch {
        print("Decoding Swatch from URL...")
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let queryItems = components?.queryItems else {
            throw NFCReaderError.noQueryItemsRead
        }
        guard queryItems.map(\.name).containsAll([URLKeys.material, URLKeys.brand, URLKeys.colorName]) else {
            throw NFCReaderError.queryItemsMissing
        }
        
        func query(_ key: String) -> String? {
            queryItems.first(where: { $0.name == key })?.value
        }
        
        guard
            let material = query(URLKeys.material),
            let brand = query(URLKeys.brand),
            let colorName = query(URLKeys.colorName)
        else {
            throw NFCReaderError.queryItemsMissing
        }
        
        let productLine = query(URLKeys.productLine)
        // We nil-coalesce the double Optionals to a single optional containing nil
        let color = query(URLKeys.colorCode).map(FilamentColor.init(hexCode:)) ?? nil
        let extruderTemp = query(URLKeys.extruderTemp).map(Int.init) ?? nil
        let bedTemp = query(URLKeys.bedTemp).map(Int.init) ?? nil
        
        return Swatch(
            material: material,
            brand: brand,
            productLine: productLine ?? "",
            colorName: colorName,
            color: color,
            extruderTemp: extruderTemp ?? 0,
            bedTemp: bedTemp ?? 0
        )
    }

    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        print("Detected \(tags.count) tags")
        
        // Do not read multiple tags
        guard tags.count <= 1 else {
            // Restart polling in 500 milliseconds.
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag is detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and perform NDEF message reading
        let tag = tags.first!
        session.connect(to: tag, completionHandler: { (error: Error?) in
            if nil != error {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus(completionHandler: { (ndefStatus: NFCNDEFStatus, capacity: Int, error: Error?) in
                if .notSupported == ndefStatus {
                    session.alertMessage = "Tag is not NDEF compliant"
                    session.invalidate()
                    return
                } else if nil != error {
                    session.alertMessage = "Unable to query NDEF status of tag"
                    session.invalidate()
                    return
                }
                
                tag.readNDEF(completionHandler: { (message: NFCNDEFMessage?, error: Error?) in
                    var statusMessage: String
                    if nil != error || nil == message {
                        statusMessage = "Fail to read NDEF from tag"
                    } else {
                        statusMessage = ""
                        // Process detected NFCNDEFMessage objects.
                        self.processMessage(message!)
                    }
                    
                    session.alertMessage = statusMessage
                    session.invalidate()
                })
            })
        })
    }
    
    func processMessage(_ message: NFCNDEFMessage) {
        // Check for an URL
        for record in message.records {
            if record.typeNameFormat == .nfcWellKnown {
                if let url = record.wellKnownTypeURIPayload() {
                    do {
                        // Decode the URL parameters
                        let swatch = try decodeSwatch(from: url)
                        continuation?.resume(returning: swatch)
                        continuation = nil
                        session?.invalidate()
                        return
                    } catch NFCReaderError.noQueryItemsRead {
                        continue // Continue with next record
                    } catch {
                        continuation?.resume(throwing: error)
                        continuation = nil
                        session?.invalidate()
                        return
                    }
                }
            }
            print(record)
        }
    }
}

extension Collection where Element: Equatable {
    func containsAll(_ elements: [Element]) -> Bool {
        for element in elements {
            if !self.contains(element) {
                return false
            }
        }
        return true
    }
}
