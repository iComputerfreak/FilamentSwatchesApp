// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import SwiftUI

extension EditMaterialView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        var material: FilamentMaterial
        
        @ObservationIgnored
        @Injected private var userData: UserData
        
        let title: LocalizedStringKey
        var name: String
        
        var isFormValid: Bool {
            guard !name.isEmpty else { return false }
            
            return userData.materials
                .filter { other in
                    other.id != material.id
                }
                .allSatisfy { material in
                    material.name != name
                }
        }

        init(material: FilamentMaterial, title: LocalizedStringKey) {
            self.material = material
            self.title = title
            
            // Initialize with default values from the material
            self.name = material.name
        }
        
        func save() {
            material.name = name
            userData.save()
        }
    }
}
