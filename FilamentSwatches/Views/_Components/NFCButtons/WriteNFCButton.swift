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
    @State var viewModel: ViewModel
    
    var body: some View {
        Button {
            Task {
                await viewModel.writeNFC()
            }
        } label: {
            Text("Write Tag")
                .prominentButtonStyle()
        }
        .padding()
        .alert("Scanning Not Supported", isPresented: $viewModel.showingNFCNotAvailableAlert) {
            okayButton
        } message: {
            Text("This device doesn't support tag scanning.")
        }
        .alert(
            "Writing Error",
            isPresented: $viewModel.isShowingGeneralError,
            actions: {
                okayButton
            },
            message: {
                let errorMessage = viewModel.generalError?.localizedDescription ?? String(localized: "An unknown error occurred.")
                Text("There was an error writing the NFC tag: \(errorMessage)")
            }
        )
    }
    
    private var okayButton: some View {
        Button("Ok") {}
    }
}

struct WriteNFCButton_Previews: PreviewProvider {
    static var previews: some View {
        WriteNFCButton(viewModel: .init(swatch: SampleData.swatch))
    }
}
