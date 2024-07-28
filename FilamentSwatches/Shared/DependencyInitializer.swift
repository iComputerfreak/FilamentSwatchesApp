import AppFoundation
import DependencyInjection
import Logging

final class DependencyInitializer {
    private let appTarget: AppTarget = .current
    
    init() {}
    
    func register() {
        #if DEBUG
        // If we are displaying Xcode Previews, use sample data
        guard !AppInfo.isRunningInPreview else {
            registerPreview()
            return
        }
        #endif
        registerLive()
    }
    
    private func registerLive() {
        DependencyContext.default.register(Logger.self) {
            ConsoleLogger()
        }
        
        DependencyContext.default.registerSingleton(UserData.self) {
            UserData()
        }
    }
    
    private func registerPreview() {
        DependencyContext.default.register(UserData.self) {
            SampleData.previewUserData
        }
        
        DependencyContext.default.register(Logger.self) {
            ConsoleLogger()
        }
    }
}
