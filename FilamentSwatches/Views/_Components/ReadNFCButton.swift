//
//  ReadNFCButton.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import CoreNFC
import DependencyInjection
import Logging
import SwiftUI

struct ReadNFCButton: View {
    @Binding var presentedSwatch: Swatch?
    @EnvironmentObject private var userData: UserData
    let reader = NFCReader()
    
    @Injected private var logger: Logger
    
    @State private var showingNFCNotAvailableAlert: Bool = false
    
    var body: some View {
        Button {
            Task {
                do {
                    guard let swatch = try await reader.scanForSwatch() else {
                        logger.error("Reader did not read a valid swatch!", category: .nfc)
                        return
                    }
                    
                    await MainActor.run {
                        if let index = userData.swatchHistory.firstIndex(where: { $0.id == swatch.id }) {
                            // Move swatch up in history
                            userData.swatchHistory.move(fromOffsets: [index], toOffset: 0)
                        } else {
                            // Add Swatch to history
                            userData.swatchHistory.insert(swatch, at: 0)
                        }
                        // Keep only the last 10 scan results
                        if userData.swatchHistory.count > UserData.maxHistoryItems {
                            userData.swatchHistory = Array(userData.swatchHistory.prefix(UserData.maxHistoryItems))
                        }
                        userData.save()
                        
                        // Show Swatch in SwatchView
                        self.presentedSwatch = swatch
                    }
                } catch NFCReaderError.readingUnavailable {
                    self.showingNFCNotAvailableAlert = true
                } catch {
                    logger.error("Error reading swatch data: \(error)", category: .nfc)
                }
            }
        } label: {
            Text("Read Tag")
                .prominentButtonStyle()
        }
        .padding()
        .alert("Scanning Not Supported", isPresented: $showingNFCNotAvailableAlert) {
            Button("Ok") {}
        } message: {
            Text("This device doesn't support tag scanning.")
        }
    }
}

struct ReadNFCButton_Previews: PreviewProvider {
    static var previews: some View {
        ReadNFCButton(presentedSwatch: .constant(nil))
    }
}
