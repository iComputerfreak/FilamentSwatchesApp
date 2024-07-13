// Copyright © 2024 Jonas Frey. All rights reserved.

public enum LogLevel: String {
    case trace
    case debug
    case info
    case warning
    case error
    case fatal
    
    public var emoji: String {
        switch self {
        case .trace:
            return "🔍"
        case .debug:
            return "🐛"
        case .info:
            return "ℹ️"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        case .fatal:
            return "💥"
        }
    }
    
    public var label: String {
        "\(rawValue.capitalized) \(emoji)"
    }
}
