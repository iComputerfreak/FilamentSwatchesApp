// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import SwiftUI

extension MaterialsView {
    struct ViewModel: ViewModelProtocol {
        var materials: [FilamentMaterial]
        
        @Injected private var userData: UserData
        
        init() {
            self.materials = []
            self.materials = userData.materials
        }
    }
}
