//
//  Logger.swift
//
//  Created by Jonas Frey on 13.07.2024
//

import OSLog

public protocol Logger {
    /// Logs a message to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The log level / severity of the message
    ///   - category: The category of the message
    func log(_ message: String, level: LogLevel, category: LoggingCategory)
    
    /// Logs a message of serverity `trace` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func trace(_ message: String, category: LoggingCategory)
    
    /// Logs a message of serverity `trace` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func trace(_ message: String)
    
    /// Logs a message of serverity `debug` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func debug(_ message: String, category: LoggingCategory)
    
    /// Logs a message of serverity `debug` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func debug(_ message: String)
    
    /// Logs a message of serverity `info` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func info(_ message: String, category: LoggingCategory)
    
    /// Logs a message of serverity `info` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func info(_ message: String)
    
    /// Logs a message of serverity `warning` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func warning(_ message: String, category: LoggingCategory)
    
    /// Logs a message of serverity `warning` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func warning(_ message: String)
    
    /// Logs a message of serverity `error` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func error(_ message: String, category: LoggingCategory)
    
    /// Logs a message of serverity `error` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func error(_ message: String)
    
    /// Logs a message of serverity `fatal` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func fatal(_ message: String, category: LoggingCategory)
    
    /// Logs a message of serverity `fatal` to the underlying logging system
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the message
    func fatal(_ message: String)
}

// MARK: - Default Implementation of Convenience Functions
public extension Logger {
    func trace(_ message: String, category: LoggingCategory = .general) {
        log(message, level: .trace, category: category)
    }
    
    func trace(_ message: String) {
        trace(message, category: .general)
    }
    
    func debug(_ message: String, category: LoggingCategory = .general) {
        log(message, level: .debug, category: category)
    }
    
    func debug(_ message: String) {
        debug(message, category: .general)
    }
    
    func info(_ message: String, category: LoggingCategory = .general) {
        log(message, level: .info, category: category)
    }
    
    func info(_ message: String) {
        info(message, category: .general)
    }
    
    func warning(_ message: String, category: LoggingCategory = .general) {
        log(message, level: .warning, category: category)
    }
    
    func warning(_ message: String) {
        warning(message, category: .general)
    }
    
    func error(_ message: String, category: LoggingCategory = .general) {
        log(message, level: .error, category: category)
    }
    
    func error(_ message: String) {
        error(message, category: .general)
    }
    
    func fatal(_ message: String, category: LoggingCategory = .general) {
        log(message, level: .fatal, category: category)
    }
    
    func fatal(_ message: String) {
        fatal(message, category: .general)
    }
}
