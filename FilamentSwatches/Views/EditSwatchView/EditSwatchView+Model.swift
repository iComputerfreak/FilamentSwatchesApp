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
            // TODO: This creates a new ID and thus changes the hash, breaking the material Picker
            self.material = FilamentMaterial(name: swatch.material)
            self.brand = swatch.brand
            self.productLine = swatch.productLine
            self.colorName = swatch.colorName
            self.extruderTemp = swatch.extruderTemp
            self.bedTemp = swatch.bedTemp
            self.isShowingColorPicker = swatch.color != nil
            self.swatchColor = swatch.color?.color ?? .white
        }
        
        func submit() {
            guard isFormValid else { return }
            
            // Update the swatch
            swatch.material = material.name
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
