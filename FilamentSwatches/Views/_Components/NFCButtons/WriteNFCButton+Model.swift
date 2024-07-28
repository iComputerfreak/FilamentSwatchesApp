// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import Foundation
import Logging

extension WriteNFCButton {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var logger: Logger
        
        @ObservationIgnored
        @Injected private var userData: UserData
        
        var showingNFCNotAvailableAlert: Bool = false
        var generalError: Error?
        var isShowingGeneralError: Bool = false
        
        let swatch: Swatch
        
        init(swatch: Swatch) {
            self.swatch = swatch
        }
        
        func writeNFC() async {
            do {
                let writer = NFCWriter(baseURL: userData.baseURL)
                let result = try await writer.writeSwatch(swatch)
                if result != true {
                    logger.error("Reader did not correctly read swatch!", category: .nfc)
                }
            } catch NFCReaderError.readingUnavailable {
                self.showingNFCNotAvailableAlert = true
            } catch {
                logger.error("Error reading swatch data: \(error)", category: .nfc)
                generalError = error
                isShowingGeneralError = true
            }
        }
    }
}
