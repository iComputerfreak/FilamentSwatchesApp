//
//  ContentView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userData: UserData = .init()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            LibraryView()
                .tabItem {
                    Image(systemName: "swatchpalette")
                    Text("Library")
                }
            
            MaterialsView()
                .tabItem {
                    Image(systemName: "cylinder.split.1x2")
                    Text("Materials")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .environmentObject(userData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
