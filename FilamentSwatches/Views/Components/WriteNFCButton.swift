//
//  WriteNFCButton.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 10.11.22.
//

import CoreNFC
import DependencyInjection
import Logging
import SwiftUI

struct WriteNFCButton: View {
    let swatch: Swatch
    
    @Injected private var logger: Logger
    
    @State private var showingNFCNotAvailableAlert = false
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        Button {
            Task {
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
                }
            }
        } label: {
            Text("Write Tag")
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

struct WriteNFCButton_Previews: PreviewProvider {
    static var previews: some View {
        ReadNFCButton(presentedSwatch: .constant(nil))
    }
}
