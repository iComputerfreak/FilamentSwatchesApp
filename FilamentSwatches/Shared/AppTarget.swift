// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation

enum AppTarget {
    case debug
    case release
    
    static var current: AppTarget {
        #if DEBUG
        return .debug
        #else
        return .release
        #endif
    }
    
    static var isDebug: Bool {
        return current == .debug
    }
    
    static var isRelease: Bool {
        return current == .release
    }
}
