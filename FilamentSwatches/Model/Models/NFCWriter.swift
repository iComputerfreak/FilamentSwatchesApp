//
//  NFCWriter.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 10.11.22.
//

import CoreNFC
import DependencyInjection
import Foundation
import Logging

enum NFCWriterError: Error {
    case writingUnavailable
    case invalidBaseURL
    case invalidURL
    case noMessage
    case newSessionWhileOldOpen
}

/// Handles writing NFC data
class NFCWriter: NFCSessionDelegate<Bool>, NFCNDEFReaderSessionDelegate {
    private var message: NFCNDEFMessage?
    var baseURL: String
    
    @Injected private var logger: Logger
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    // Start of the lifecycle. Request to write a swatch to an NFC tag
    func writeSwatch(_ swatch: Swatch) async throws -> Bool {
        logger.info("Writing Swatch \(swatch)", category: .nfc)
        guard NFCNDEFReaderSession.readingAvailable else {
            throw NFCWriterError.writingUnavailable
        }
        
        // There should not be an existing session already in progress
        guard session == nil && continuation == nil else {
            logger.info("Session already in progress", category: .nfc)
            throw NFCWriterError.newSessionWhileOldOpen
        }
        
        try self.updateMessage(for: swatch)
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            session?.begin()
        }
    }
    
    private func updateMessage(for swatch: Swatch) throws {
        // Construct the URL
        let url = try url(for: swatch)
        
        guard let payload = NFCNDEFPayload.wellKnownTypeURIPayload(url: url) else {
            throw NFCWriterError.invalidURL
        }
        
        // Create NDEF message and NFC session
        self.message = NFCNDEFMessage(records: [payload])
        self.session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
    }
    
    /// Builds an URL that displays the data of the given `Swatch`
    /// - Parameter swatch: The `Swatch` to generate the URL for
    /// - Returns: The generated URL
    /// - Throws: Errors during URL generation
    private func url(for swatch: Swatch) throws -> URL {
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
        
        return url
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        logger.info("Reader session active", category: .nfc)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        logger.info("Reader session invalidated", category: .nfc)
        if
            let nfcError = error as? CoreNFC.NFCReaderError,
            // Code 200 == "Session invalidated by user"
            nfcError.errorCode == 200
        {
            continuation?.resume(returning: false)
        } else {
            continuation?.resume(throwing: error)
        }
        continuation = nil
        // Invalidate session, if we did not already start a new one
        if self.session == session {
            self.session = nil
        }
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        logger.info("Detected \(messages.count) messages", category: .nfc)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        logger.info("Detected \(tags.count) tags", category: .nfc)
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
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval) {
                session.restartPolling()
            }
            return
        }
        
        // MARK: Process the tag
        let tag = tags.first!
        
        Task(priority: .userInitiated) {
            // Connect to the found tag and write an NDEF message to it.
            do {
                try await session.connect(to: tag)
                let (ndefStatus, _) = try await tag.queryNDEFStatus()
                
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant."
                case .readOnly:
                    session.alertMessage = "Tag is read only."
                case .readWrite:
                    try await tag.writeNDEF(message)
                    self.finish(session, with: .success(true), message: "Write successful!")
                    return
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                }
                
                // Do not update the message, as we already did that
                self.finish(session, with: .success(false), message: nil)
            } catch {
                // TODO: Restart polling instead?
                self.finish(session, with: .failure(error), message: nil)
            }
        }
    }
}
