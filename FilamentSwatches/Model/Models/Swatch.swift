//
//  Swatch.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import Foundation

@Observable
class Swatch: Identifiable, Codable {
    enum CodingKeys: String, CodingKey {
        // swiftlint:disable identifier_name
        case _id = "id"
        case _material = "material"
        case _brand = "brand"
        case _productLine = "productLine"
        case _colorName = "colorName"
        case _color = "color"
        case _extruderTemp = "extruderTemp"
        case _bedTemp = "bedTemp"
        // swiftlint:enable identifier_name
    }
    
    var id = UUID()
    
    var material: FilamentMaterial
    var brand: String
    var productLine: String
    var colorName: String
    var color: FilamentColor?
    var extruderTemp: Int = 0
    var bedTemp: Int = 0
    
    var descriptiveName: String {
        "\(productLine.isEmpty ? brand : productLine) \(colorName) \(material.name)"
            .trimmingCharacters(in: .whitespaces)
    }
    
    var isValid: Bool {
        !material.name.isEmpty &&
        !brand.isEmpty &&
        !colorName.isEmpty
    }
    
    init(
        material: FilamentMaterial,
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
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self._id = try container.decode(UUID.self, forKey: ._id)
        if let legacyMaterial = try? container.decodeIfPresent(String.self, forKey: ._material) {
            self._material = FilamentMaterial(name: legacyMaterial)
        } else {
            self._material = try container.decode(FilamentMaterial.self, forKey: ._material)
        }
        self._brand = try container.decode(String.self, forKey: ._brand)
        self._productLine = try container.decode(String.self, forKey: ._productLine)
        self._colorName = try container.decode(String.self, forKey: ._colorName)
        self._color = try container.decodeIfPresent(FilamentColor.self, forKey: ._color)
        self._extruderTemp = try container.decode(Int.self, forKey: ._extruderTemp)
        self._bedTemp = try container.decode(Int.self, forKey: ._bedTemp)
    }
}

extension Swatch: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(material)
        hasher.combine(brand)
        hasher.combine(productLine)
        hasher.combine(colorName)
        hasher.combine(color)
        hasher.combine(extruderTemp)
        hasher.combine(bedTemp)
    }
}

extension Swatch: Equatable {
    static func == (lhs: Swatch, rhs: Swatch) -> Bool {
        return lhs.id == rhs.id &&
        lhs.material == rhs.material &&
        lhs.brand == rhs.brand &&
        lhs.productLine == rhs.productLine &&
        lhs.colorName == rhs.colorName &&
        lhs.color == rhs.color &&
        lhs.extruderTemp == rhs.extruderTemp &&
        lhs.bedTemp == rhs.bedTemp
    }
}
