// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation

public enum LoggingCategory: Hashable {
    case general
    case network
    case viewLifecycle
    case nfc
    case userData
    case file(_ file: String = #file)
    
    public var identifier: String {
        switch self {
        case .general:
            return "general"
        
        case .network:
            return "network"
        
        case .viewLifecycle:
            return "viewLifecycle"
        
        case .nfc:
            return "nfc"
        
        case .userData:
            return "userData"
        
        case .file:
            return "file_\(fileName)"
        }
    }
    
    public var label: String {
        switch self {
        case .general:
            return "[General 📒]"
        
        case .network:
            return "[Network 🌐]"
        
        case .viewLifecycle:
            return "[View Lifecycle 🔄]"
        
        case .nfc:
            return "[NFC 📲]"
        
        case .userData:
            return "[User Data 📦]"
        
        case .file:
            return "[File 🏷️] [\(fileName)]"
        }
    }
    
    private var fileName: String {
        switch self {
        case let .file(fileName):
            return String(
                fileName
                    .split(separator: "/")
                    .last
                ?? ""
            )
        
        default:
            return ""
        }
    }
}
