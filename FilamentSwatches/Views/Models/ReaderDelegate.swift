//
//  NFCReader.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 08.11.22.
//

import Foundation
import CoreNFC

enum NFCError: Error {
    case readingUnavailable
}

class NFCReader: NSObject, NFCNDEFReaderSessionDelegate {
    
    private var continuation: CheckedContinuation<Swatch, Error>?
    
    func scanForSwatch() async throws -> Swatch? {
        guard NFCNDEFReaderSession.readingAvailable else {
            throw NFCError.readingUnavailable
        }
        
        // Read NFC Data
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        
        return try await withCheckedThrowingContinuation({ continuation in
            self.continuation = continuation
            session.begin()
        })
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        continuation?.resume(throwing: error)
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            print(message.records)
        }
        
        let swatch = Swatch(material: "", brand: "", colorName: "") // TODO: Create from messages
        
        continuation?.resume(returning: swatch)
    }
}
