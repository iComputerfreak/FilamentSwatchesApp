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
        var isShowingAddSwatchSheet: Bool = false
        
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
                    swatch.material == material.name
                }
                .sorted { lhs, rhs in
                    if lhs.brand == rhs.brand {
                        return lhs.colorName < rhs.colorName
                    }
                    return lhs.brand < rhs.brand
                }
        }
        
        func deleteMaterials(at indexSet: IndexSet) {
            userData.materials.remove(atOffsets: indexSet)
            userData.save()
        }
    }
}
