import Foundation

@propertyWrapper
public struct Injected<Value> {
    private let key: String?
    
    public var wrappedValue: Value {
        DependencyContext.default.resolve(key: key)
    }
    
    public init() {
        self.key = nil
    }
    
    public init<Key>(key: Key) where Key: RawRepresentable<String> {
        self.key = key.rawValue
    }
}
