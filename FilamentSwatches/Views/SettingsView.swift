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
    
    var body: some View {
        Form {
            TextField("Base URL", text: $userData.baseURL)
                .keyboardType(.URL)
                .autocorrectionDisabled()
                .onChange(of: userData.baseURL) { _ in
                    userData.save()
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
