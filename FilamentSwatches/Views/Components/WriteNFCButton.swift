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
    let writer = NFCWriter()
    
    @State private var showingNFCNotAvailableAlert = false
    
    var body: some View {
        Button {
            Task {
                do {
                    let result = try await writer.writeSwatch(swatch)
                    if result != true {
                        print("Reader did not correctly read swatch!")
                    }
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
