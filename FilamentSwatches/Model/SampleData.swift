//
//  SampleData.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import DependencyInjection
import Foundation

enum SampleData {
    static let swatch = Swatch(
        material: .init(name: "PLA"),
        brand: "Polymaker",
        productLine: "PolyLite",
        colorName: "Teal",
        color: .init(hexCode: "4AFFF8"),
        extruderTemp: 200,
        bedTemp: 60
    )
    
    static let previewUserData: UserData = {
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
    
    static func populateScreenshotData() {
        let userData: UserData = DependencyContext.default.resolve()
        userData.materials = ["PLA", "PETG", "ABS"].map { .init(name: $0) }
        userData.swatches = [
            .init(
                material: .init(name: "PLA"),
                brand: "Polymaker",
                productLine: "PolyLite",
                colorName: "Red",
                color: .init(hexCode: "CD4F4A"),
                extruderTemp: 215,
                bedTemp: 70
            ),
            .init(
                material: .init(name: "PLA"),
                brand: "Polymaker",
                productLine: "PolyLite",
                colorName: "Yellow",
                color: .init(hexCode: "FBE94E"),
                extruderTemp: 215,
                bedTemp: 70
            ),
            .init(
                material: .init(name: "PLA"),
                brand: "Eryone",
                colorName: "Gray",
                color: .init(hexCode: "ADADAD"),
                extruderTemp: 215,
                bedTemp: 70
            ),
            .init(
                material: .init(name: "PLA"),
                brand: "Prusament",
                colorName: "Gentleman's Grey",
                color: .init(hexCode: "455767"),
                extruderTemp: 215,
                bedTemp: 70
            ),
            .init(
                material: .init(name: "PETG"),
                brand: "3DJake",
                colorName: "Duneklblau",
                color: .init(hexCode: "2A3F97"),
                extruderTemp: 245,
                bedTemp: 80
            ),
            .init(
                material: .init(name: "ABS"),
                brand: "Polymaker",
                productLine: "PolyLite",
                colorName: "Teal",
                color: .init(hexCode: "65C9D1"),
                extruderTemp: 240,
                bedTemp: 95
            ),
        ]
        userData.swatchHistory = userData.swatches.sorted { lhs, rhs in
            lhs.colorName < rhs.colorName
        }
    }
}
