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
    var extruderTemp: Int
    var bedTemp: Int
    var attributes: [String: String]
    
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
        bedTemp: Int = 0,
        attributes: [String: String] = [:]
    ) {
        self.material = material
        self.brand = brand
        self.productLine = productLine
        self.colorName = colorName
        self.color = color
        self.extruderTemp = extruderTemp
        self.bedTemp = bedTemp
        self.attributes = attributes
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.material = try container.decode(String.self, forKey: .material)
        self.brand = try container.decode(String.self, forKey: .brand)
        self.productLine = try container.decode(String.self, forKey: .productLine)
        self.colorName = try container.decode(String.self, forKey: .colorName)
        self.color = try container.decodeIfPresent(FilamentColor.self, forKey: .color)
        self.extruderTemp = try container.decode(Int.self, forKey: .extruderTemp)
        self.bedTemp = try container.decode(Int.self, forKey: .bedTemp)
        // NOTE: attributes were added in a later version, so they might not be present
        self.attributes = try container.decodeIfPresent([String: String].self, forKey: .attributes) ?? [:]
    }
}
