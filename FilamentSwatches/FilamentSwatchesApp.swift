//
//  FilamentSwatchesApp.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import DependencyInjection
import SwiftUI

@main
struct FilamentSwatchesApp: App {
    @Environment(\.scenePhase)
    private var scenePhase: ScenePhase
    
    @Injected private var userData: UserData
    
    // swiftlint:disable:next type_contents_order
    init() {
        DependencyInitializer().register()
        
        // MARK: Prepare for UI testing or screenshots
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--screenshots") {
            SampleData.populateScreenshotData()
        }
        #endif
    }
    
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
