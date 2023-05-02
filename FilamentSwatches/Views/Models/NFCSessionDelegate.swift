//
//  NFCSessionDelegate.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 02.05.23.
//

import CoreNFC
import Foundation

class NFCSessionDelegate<ResultType>: NSObject {
    var session: NFCNDEFReaderSession?
    var continuation: CheckedContinuation<ResultType, Error>?
    
    func finish(
        _ session: NFCNDEFReaderSession? = nil,
        with result: Result<ResultType, Error>,
        message: String? = nil
    ) {
        let session = session ?? self.session
        if let message {
            session?.alertMessage = message
        } else if case let .failure(error) = result {
            // If we return an error, display the error message
            session?.alertMessage = error.localizedDescription
        }
        self.continuation?.resume(with: result)
        self.continuation = nil
        session?.invalidate()
    }
}
