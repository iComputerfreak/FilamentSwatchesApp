//
//  ReadNFCButton.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI
import CoreNFC

struct ReadNFCButton: View {
    @Binding var presentedSwatch: Swatch?
    @EnvironmentObject private var userData: UserData
    let reader = NFCReader()
    
    @State private var showingNFCNotAvailableAlert = false
    
    var body: some View {
        Button {
            Task {
                do {
                    guard let swatch = try await reader.scanForSwatch() else {
                        print("Reader did not read a valid swatch!")
                        return
                    }
                    
                    await MainActor.run {
                        // Add Swatch to history
                        userData.swatchHistory.insert(swatch, at: 0)
                        // Keep only the last 10 scan results
                        while userData.swatchHistory.count > 10 {
                            userData.swatchHistory.removeLast()
                        }
                        userData.save()
                        
                        // Show Swatch in SwatchView
                        self.presentedSwatch = swatch
                    }
                } catch {
                    print(error)
                }
            }
        } label: {
            Text("Read Tag")
                .bigProminentButtonStyle()
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
