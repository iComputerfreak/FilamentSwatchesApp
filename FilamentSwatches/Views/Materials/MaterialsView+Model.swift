// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import SwiftUI

extension MaterialsView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
        var editingMaterial: FilamentMaterial?
        
        var materials: [FilamentMaterial] {
            userData.materials
                // Only include valid materials, so we don't show the empty material entry while creating a new one
                .filter { material in
                    !material.name.isEmpty
                }
        }

        init() {}
        
        func addMaterial() {
            let newMaterial = FilamentMaterial(name: "")
            userData.materials.append(newMaterial)
            self.editingMaterial = newMaterial
        }
        
        func onEditMaterialSheetDismiss() {
            // Delete the material(s) with an empty name that we created in `addMaterial()` again
            userData.materials.removeAll(where: \.name.isEmpty)
        }
    }
}
