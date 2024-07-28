//
//  ReadNFCButton.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import AppFoundation
import CoreNFC
import DependencyInjection
import Logging
import SwiftUI

struct ReadNFCButton: StatefulView {
    @State var viewModel: ViewModel
    
    var body: some View {
        Button {
            Task {
                await viewModel.readNFC()
            }
        } label: {
            Text("Read Tag")
                .prominentButtonStyle()
        }
        .padding()
        .alert("Scanning Not Supported", isPresented: $viewModel.showingNFCNotAvailableAlert) {
            okayButton
        } message: {
            Text("This device doesn't support tag scanning.")
        }
        .alert(
            "Scanning Error",
            isPresented: $viewModel.isShowingGeneralError,
            actions: {
                okayButton
            },
            message: {
                let errorMessage = viewModel.scanError?.localizedDescription ?? String(localized: "An unknown error occurred.")
                Text("There was an error scanning the NFC tag: \(errorMessage)")
            }
        )
        .sheet(item: $viewModel.presentedSwatch) { swatch in
            SwatchView(viewModel: .init(swatch: swatch))
        }
    }
    
    private var okayButton: some View {
        Button("Ok") {}
    }
}

struct ReadNFCButton_Previews: PreviewProvider {
    static var previews: some View {
        ReadNFCButton()
    }
}
