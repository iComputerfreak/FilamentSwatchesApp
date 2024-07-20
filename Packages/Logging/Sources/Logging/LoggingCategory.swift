// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation

public enum LoggingCategory: String, CaseIterable, Hashable {
    case general
    case network
    case viewLifecycle
    case nfc
    case persistence
    
    public var identifier: String {
       rawValue
    }
    
    public var label: String {
        switch self {
        case .general:
            return "General 📒"
        case .network:
            return "Network 🌐"
        case .viewLifecycle:
            return "View Lifecycle 🔄"
        case .nfc:
            return "NFC 📲"
        case .persistence:
            return "Persistence 📦"
        }
    }
}
