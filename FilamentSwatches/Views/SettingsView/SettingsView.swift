//
//  SettingsView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 14.11.22.
//

import AppFoundation
import SwiftUI

struct SettingsView: StatefulView {
    @State var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
			Form {
				Section {
                    TextField(viewModel.baseURL, text: $viewModel.baseURL, prompt: Text(viewModel.defaultBaseURL))
						.keyboardType(.URL)
						.autocorrectionDisabled()
                } header: {
                    HStack {
                        Text("Base URL")
                        Spacer()
                        infoButton
                    }
                }
			}
			.navigationTitle("Settings")
            .alert(
                "Base URL Customization",
                isPresented: $viewModel.isShowingBaseURLInfoSheet,
                actions: {
                    Button("Ok") {}
                },
                message: {
                    Text(String(
                        // swiftlint:disable:next line_length
                        localized: "The base URL is used for encoding the swatch information onto the NFC tags so that other devices without the app installed can display the information as well. If you would like to host your own swatch information website (e.g., to customize the looks), take a look at https://github.com/iComputerfreak/FilamentInfo."
                    ))
                }
            )
        }
    }
    
    private var infoButton: some View {
        Button {
            viewModel.isShowingBaseURLInfoSheet = true
        } label: {
            Image(systemName: "info.circle")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: .init())
    }
}
