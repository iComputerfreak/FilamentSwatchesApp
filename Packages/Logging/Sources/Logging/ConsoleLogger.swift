// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation
import os.log

public class ConsoleLogger: Logger {
    private let subsystem: String = Bundle.main.bundleIdentifier ?? UUID().uuidString
    
    public init() {}
    
    public func log(_ message: String, level: LogLevel, category: LoggingCategory) {
        os_log(
            osLogLevel(for: level),
            log: .init(subsystem: subsystem, category: category.label),
            "\(level.label) \(category.label) \(message)"
        )
    }
    
    private func osLogLevel(for logLevel: LogLevel) -> OSLogType {
        switch logLevel {
        case .trace, .debug:
            return .debug
            
        case .info, .warning:
            return .info
            
        case .error:
            return .error
            
        case .fatal:
            return .fault
        }
    }
}
