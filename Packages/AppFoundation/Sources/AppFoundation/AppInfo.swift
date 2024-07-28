// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation

public enum AppInfo {
    public static var isRunningInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
