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
    var appDelegate: AppDelegate
    
    @ObservedObject var userData: UserData = .shared
   
    @Environment(\.scenePhase)
    private var scenePhase: ScenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { _, newValue in
                    if newValue == .background {
                        userData.save()
                    }
                }
        }
    }
}
