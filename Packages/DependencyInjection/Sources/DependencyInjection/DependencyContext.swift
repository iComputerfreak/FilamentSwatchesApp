// Copyright © 2024 Jonas Frey. All rights reserved.

import Foundation
import Swinject

public final class DependencyContext {
    public static let `default` = DependencyContext()
    
    private let container: Container
    
    public init() {
        self.container = Container()
    }
    
    public func resolve<Value>(key: String? = nil) -> Value {
        guard let value = container.resolve(Value.self, name: key) else {
            let typeDescription = String(describing: Value.self)
            let keyDescription = key.map { " with key \($0)" } ?? ""
            fatalError(
                "Error resolving dependency of type \(typeDescription)\(keyDescription). Did you forget to register it?"
            )
        }
        return value
    }
    
    public func register<Value>(
        _ type: Value.Type,
        key: String? = nil,
        builder: @escaping () -> Value
    ) {
        container.register(Value.self, name: key) { _ in
            builder()
        }
    }
    
    public func registerSingleton<Value>(
        _ type: Value.Type,
        key: String? = nil,
        builder: @escaping () -> Value
    ) {
        container.register(Value.self, name: key) { _ in
            builder()
        }
        .inObjectScope(.container)
    }
}
