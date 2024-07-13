//
//  SampleData.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import Foundation

enum SampleData {
    static let swatch = Swatch(
        material: "PLA",
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
            "PLA",
            "ABS",
            "ABS+",
            "PETG",
        ]
        data.swatchHistory = [Self.swatch]
        return data
    }()
    
    static func populateScreenshotData() {
        let userData = UserData.shared
        userData.materials = ["PLA", "PETG", "ABS"]
        userData.swatches = [
            .init(
                material: "PLA",
                brand: "Polymaker",
                productLine: "PolyLite",
                colorName: "Red",
                color: .init(hexCode: "CD4F4A"),
                extruderTemp: 215,
                bedTemp: 70
            ),
            .init(
                material: "PLA",
                brand: "Polymaker",
                productLine: "PolyLite",
                colorName: "Yellow",
                color: .init(hexCode: "FBE94E"),
                extruderTemp: 215,
                bedTemp: 70
            ),
            .init(
                material: "PLA",
                brand: "Eryone",
                colorName: "Gray",
                color: .init(hexCode: "ADADAD"),
                extruderTemp: 215,
                bedTemp: 70
            ),
            .init(
                material: "PLA",
                brand: "Prusament",
                colorName: "Gentleman's Grey",
                color: .init(hexCode: "455767"),
                extruderTemp: 215,
                bedTemp: 70
            ),
            .init(
                material: "PETG",
                brand: "3DJake",
                colorName: "Duneklblau",
                color: .init(hexCode: "2A3F97"),
                extruderTemp: 245,
                bedTemp: 80
            ),
            .init(
                material: "ABS",
                brand: "Polymaker",
                productLine: "PolyLite",
                colorName: "Teal",
                color: .init(hexCode: "65C9D1"),
                extruderTemp: 240,
                bedTemp: 95
            ),
        ]
        userData.swatchHistory = userData.swatches.sorted { s1, s2 in
            s1.colorName < s2.colorName
        }
    }
}
