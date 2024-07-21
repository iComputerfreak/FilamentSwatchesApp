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
					TextField(viewModel.baseURL, text: $viewModel.baseURL)
						.keyboardType(.URL)
						.autocorrectionDisabled()
				} footer: {
                    Text(
                        "The base URL is used for encoding the swatch information onto the NFC tags so that other devices without the app installed " +
                        "can display the information aswell. If you would like to host your own swatch information website (e.g. to customize the looks), " +
                        "take a look at https://github.com/iComputerfreak/FilamentInfo."
                    )
				}
			}
			.navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: .init())
            .environmentObject(SampleData.previewUserData)
    }
}
