//
//  ReadNFCButton.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct ReadNFCButton: View {
    @Binding var presentedSwatch: Swatch?
    
    var body: some View {
        Button {
            // TODO: Read NFC Data
            
            // Create Swatch from data
            let swatch = SampleData.swatch
            
            // Show Swatch in SwatchView
            self.presentedSwatch = swatch
        } label: {
            Text("Read Tag")
                .foregroundColor(.white)
                .font(.title)
                .padding(.vertical, 20)
                .padding(.horizontal, 40)
                .background(
                    LinearGradient(
                        colors: [.blue, .indigo],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                )
        }
        .padding()
    }
}

struct ReadNFCButton_Previews: PreviewProvider {
    static var previews: some View {
        ReadNFCButton(presentedSwatch: .constant(nil))
    }
}
