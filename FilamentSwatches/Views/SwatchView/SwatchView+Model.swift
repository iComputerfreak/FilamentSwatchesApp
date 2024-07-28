// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import Foundation
import Logging

extension SwatchView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
        @ObservationIgnored
        @Injected private var logger: Logger
        
        let swatch: Swatch
        
        var isInLibrary: Bool {
            userData.swatches.contains { $0.arePropertiesEqual(to: swatch) }
        }
        
        init(swatch: Swatch) {
            self.swatch = swatch
        }
        
        func addToLibrary() {
            logger.debug("Adding swatch to library: \(swatch.descriptiveName)", category: .userData)
            userData.importSwatch(swatch)
        }
    }
}
