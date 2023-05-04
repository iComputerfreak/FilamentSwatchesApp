//
//  WriteNFCButton.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 10.11.22.
//

import SwiftUI
import CoreNFC

struct WriteNFCButton: View {
    let swatch: Swatch
    
    @State private var showingNFCNotAvailableAlert = false
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        Button {
            Task {
                do {
                    let writer = NFCWriter(baseURL: userData.baseURL)
                    let result = try await writer.writeSwatch(swatch)
                    if result != true {
                        print("Reader did not correctly read swatch!")
                    }
                } catch NFCReaderError.readingUnavailable {
                    self.showingNFCNotAvailableAlert = true
                } catch {
                    print(error)
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
