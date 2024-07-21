// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import Foundation

extension SwatchView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
        let swatch: Swatch
        
        var isInLibrary: Bool {
            userData.swatches.contains(swatch)
        }
        
        init(swatch: Swatch) {
            self.swatch = swatch
        }
        
        func addToLibrary() {
            userData.swatches.append(swatch)
        }
    }
}
