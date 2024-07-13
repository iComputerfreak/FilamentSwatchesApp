// Copyright © 2024 Jonas Frey. All rights reserved.

import DependencyInjection
import Logging

final class DependencyInitializer {
    init() {}
    
    func register() {
        DependencyContext.default.register(Logger.self) {
            ConsoleLogger()
        }
    }
}
