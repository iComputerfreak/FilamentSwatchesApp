//
//  Swatch.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import Foundation

struct Swatch: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var material: String
    var brand: String
    var productLine: String
    var colorName: String
    var color: FilamentColor?
    var extruderTemp: Int = 0
    var bedTemp: Int = 0
    
    var descriptiveName: String {
        "\(productLine.isEmpty ? brand : productLine) \(colorName) \(material)"
            .trimmingCharacters(in: .whitespaces)
    }
    
    var isValid: Bool {
        !material.isEmpty &&
        !brand.isEmpty &&
        !colorName.isEmpty
    }
    
    init(
        material: String,
        brand: String,
        productLine: String = "",
        colorName: String,
        color: FilamentColor? = nil,
        extruderTemp: Int = 0,
        bedTemp: Int = 0
    ) {
        self.material = material
        self.brand = brand
        self.productLine = productLine
        self.colorName = colorName
        self.color = color
        self.extruderTemp = extruderTemp
        self.bedTemp = bedTemp
    }
}
