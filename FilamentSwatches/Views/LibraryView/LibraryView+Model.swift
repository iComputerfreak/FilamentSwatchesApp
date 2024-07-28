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
            userData.swatches
                .map(\.material)
                .removingDuplicates()
                .sorted { $0.name.lexicographicallyPrecedes($1.name) }
        }
        
        init() {}
        
        func swatches(for material: FilamentMaterial) -> [Swatch] {
            userData.swatches
                // Only return swatches for the given material
                .filter { swatch in
                    swatch.material == material
                }
                // Don't show swatches that are invalid, so we don't show the empty swatch entry while creating a new one
                .filter { swatch in
                    swatch.isValid
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
        
        func onEditSwatchSheetDismiss() {
            // Delete the invalid swatch(es) that we created in `addSwatch()` again
            userData.swatches.removeAll(where: \.isValid, equals: false)
        }
    }
}
