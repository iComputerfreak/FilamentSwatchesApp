//
//  AppDelegate.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 04.05.23.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // MARK: Prepare for UI testing or screenshots
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--screenshots") {
            SampleData.populateScreenshotData()
        }
        #endif
        
        return true
    }
}
