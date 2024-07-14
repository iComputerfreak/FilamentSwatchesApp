// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import SwiftUI

extension EditMaterialView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Binding var material: FilamentMaterial
        
        @ObservationIgnored
        @Injected private var userData: UserData
        
        var name: String
        
        var isValid: Bool {
            guard !name.isEmpty else { return false }
            
            return userData.materials
                .filter { other in
                    other.id != material.id
                }
                .allSatisfy { material in
                    material.name != name
                }
        }

        init(material: Binding<FilamentMaterial>) {
            self._material = material
            
            // Initialize with default values from the material
            self.name = material.wrappedValue.name
        }
        
        func save() {
            material.name = name
            userData.save()
        }
    }
}
