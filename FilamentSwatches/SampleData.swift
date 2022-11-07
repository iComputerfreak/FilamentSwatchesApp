//
//  SampleData.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import Foundation

struct SampleData {
    static let swatch = Swatch(
        material: .init(name: "PLA"),
        brand: "Polymaker",
        productLine: "PolyLite",
        colorName: "Teal",
        color: .init(hexCode: "4AFFF8"),
        extruderTemp: 200,
        bedTemp: 60
    )
    
    static let userData: UserData = {
        let data = UserData()
        data.swatches = [Self.swatch]
        data.materials = [
            .init(name: "PLA"),
            .init(name: "ABS"),
            .init(name: "ABS+"),
            .init(name: "PETG"),
        ]
        data.swatchHistory = [Self.swatch]
        return data
    }()
}
