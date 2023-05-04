//
//  SettingsView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 14.11.22.
//

import SwiftUI
import Foundation

struct SettingsView: View {
    
    @EnvironmentObject private var userData: UserData
    @State private var setupInfoShowing = false
    
    var body: some View {
        NavigationStack {
			Form {
				Section {
					TextField("Base URL", text: $userData.baseURL)
						.keyboardType(.URL)
						.autocorrectionDisabled()
						.onChange(of: userData.baseURL) { _ in
							userData.save()
						}
				} footer: {
					Text("The base URL is used for encoding the swatch information onto the NFC tags so that other devices without the app installed can display the information aswell. If you would like to host your own swatch information website (e.g. to customize the looks), take a look at https://github.com/iComputerfreak/FilamentInfo.")
				}
			}
			.navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserData.shared)
    }
}
