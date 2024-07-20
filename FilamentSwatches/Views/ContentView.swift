//
//  ContentView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView(viewModel: .init())
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                        .accessibilityIdentifier("home-tab")
                }
            
            LibraryView()
                .tabItem {
                    Image(systemName: "swatchpalette")
                    Text("Library")
                        .accessibilityIdentifier("library-tab")
                }
            
            MaterialsView(viewModel: .init())
                .tabItem {
                    Image(systemName: "cylinder.split.1x2")
                    Text("Materials")
                        .accessibilityIdentifier("materials-tab")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                        .accessibilityIdentifier("settings-tab")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
