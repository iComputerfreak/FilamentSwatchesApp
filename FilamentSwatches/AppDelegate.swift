//
//  AppDelegate.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 04.05.23.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    static var testingScreenshots = false
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // MARK: Prepare for UI testing or screenshots
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--screenshots") {
            Self.testingScreenshots = true
        }
        #endif
        
        return true
    }
}
