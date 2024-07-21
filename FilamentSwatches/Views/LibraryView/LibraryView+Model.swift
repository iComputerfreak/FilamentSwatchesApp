// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import JFUtils
import SwiftUI

extension LibraryView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
        var selectedSwatch: Swatch?
        var editingSwatch: Swatch?
        private(set) var editSwatchTitle: LocalizedStringKey = "Edit Swatch"
        
        var materials: [FilamentMaterial] {
            userData.materials
        }
        
        var swatches: [Swatch] {
            userData.swatches
        }
        
        init() {}
        
        func swatches(for material: FilamentMaterial) -> [Swatch] {
            swatches
                .filter { swatch in
                    swatch.material == material
                }
                .sorted { lhs, rhs in
                    if lhs.brand == rhs.brand {
                        return lhs.colorName < rhs.colorName
                    }
                    return lhs.brand < rhs.brand
                }
        }
        
        func addSwatch() {
            let newSwatch = Swatch(material: .init(name: ""), brand: "", colorName: "")
            userData.swatches.append(newSwatch)
            editSwatchTitle = "Create Swatch"
            editingSwatch = newSwatch
        }
        
        func editSwatch(_ swatch: Swatch) {
            editSwatchTitle = "Edit Swatch"
            editingSwatch = swatch
        }
        
        func deleteMaterials(at indexSet: IndexSet) {
            userData.materials.remove(atOffsets: indexSet)
            userData.save()
        }
    }
}
