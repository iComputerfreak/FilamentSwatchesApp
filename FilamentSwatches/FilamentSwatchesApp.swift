//
//  FilamentSwatchesApp.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

@main
struct FilamentSwatchesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    
    @ObservedObject var userData: UserData = .shared
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
                .onChange(of: scenePhase) { newValue in
                    if newValue == .background {
                        userData.save()
                    }
                }
        }
    }
}
