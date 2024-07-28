// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import DependencyInjection
import Foundation
import Logging
import SwiftUI

extension EditSwatchView {
    @Observable
    final class ViewModel: ViewModelProtocol {
        @ObservationIgnored
        @Injected private var userData: UserData
        
        @ObservationIgnored
        @Injected private var logger: Logger
        
        let title: LocalizedStringKey
        let noMaterialSelection: FilamentMaterial
        
        let swatchID: UUID
        var material: FilamentMaterial
        var brand: String
        var productLine: String
        var colorName: String
        var extruderTemp: Int
        var bedTemp: Int
        
        var isShowingColorPicker: Bool
        var swatchColor: Color
        
        private let swatch: Swatch
            
        var materials: [FilamentMaterial] {
            userData.materials
                .sorted { $0.name.lexicographicallyPrecedes($1.name) }
        }
        
        var isFormValid: Bool {
            !material.name.isEmpty &&
            !brand.isEmpty &&
            !colorName.isEmpty
        }
        
        init(swatch: Swatch, title: LocalizedStringKey) {
            self.title = title
            self.swatch = swatch
            
            self.swatchID = swatch.id
            self.material = swatch.material
            self.brand = swatch.brand
            self.productLine = swatch.productLine
            self.colorName = swatch.colorName
            self.extruderTemp = swatch.extruderTemp
            self.bedTemp = swatch.bedTemp
            self.isShowingColorPicker = swatch.color != nil
            self.swatchColor = swatch.color?.color ?? .white
            if swatch.material.name.isEmpty {
                // Set the "Select..." option to the swatch's material (so the ID matches)
                self.noMaterialSelection = swatch.material
            } else {
                self.noMaterialSelection = .init(name: "")
            }
        }
        
        func submit() {
            guard isFormValid else { return }
            
            // Update the swatch
            swatch.material = material
            swatch.brand = brand
            swatch.productLine = productLine
            swatch.colorName = colorName
            swatch.color = isShowingColorPicker ? .init(color: swatchColor) : nil
            swatch.extruderTemp = extruderTemp
            swatch.bedTemp = bedTemp
            
            userData.save()
        }
    }
}
