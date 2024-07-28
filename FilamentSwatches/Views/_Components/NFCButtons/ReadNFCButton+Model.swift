// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import Foundation
import Logging

extension ReadNFCButton {
    @Observable
    final class ViewModel: ViewModelProtocol {
        private enum Constants {
            static let maxHistoryItems: Int = 10
        }
        @ObservationIgnored
        @Injected private var userData: UserData
        
        @ObservationIgnored
        @Injected private var logger: Logger
        
        let reader: NFCReader = .init()
        var showingNFCNotAvailableAlert: Bool = false
        var generalError: Error?
        var isShowingGeneralError: Bool = false
        var presentedSwatch: Swatch?
        
        func readNFC() async {
            do {
                guard let swatch = try await reader.scanForSwatch() else {
                    logger.error("Reader did not read a valid swatch!", category: .nfc)
                    return
                }
                
                await MainActor.run {
                    if let index = userData.swatchHistory.firstIndex(where: { $0.arePropertiesEqual(to: swatch) }) {
                        // Move swatch up in history
                        userData.swatchHistory.move(fromOffsets: [index], toOffset: 0)
                    } else {
                        // Add Swatch to history
                        userData.swatchHistory.insert(swatch, at: 0)
                    }
                    // Keep only the last 10 scan results
                    if userData.swatchHistory.count > Constants.maxHistoryItems {
                        userData.swatchHistory = Array(userData.swatchHistory.prefix(UserData.maxHistoryItems))
                    }
                    userData.save()
                    
                    // Show Swatch in SwatchView
                    presentedSwatch = swatch
                }
            } catch NFCReaderError.readingUnavailable {
                self.showingNFCNotAvailableAlert = true
            } catch {
                logger.error("Error reading swatch data: \(error)", category: .nfc)
                self.generalError = error
                self.isShowingGeneralError = true
            }
        }
    }
}
