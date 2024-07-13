//
//  FilamentColor.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import Foundation
import SwiftUI

struct FilamentColor: Codable, Hashable {
    var red: UInt8
    var green: UInt8
    var blue: UInt8
    
    var hexCode: String {
        String(format: "%02X%02X%02X", red, green, blue)
    }
    
    var color: Color {
        Color(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255
        )
    }
    
    init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    init?(hexCode: String) {
        guard
            hexCode.count == 6,
            let red = UInt64(hexCode.prefix(2), radix: 16),
            let green = UInt64(hexCode.dropFirst(2).prefix(2), radix: 16),
            let blue = UInt64(hexCode.suffix(2), radix: 16)
        else {
            return nil
        }
        
        // red, green and blue are between 0 and 255, because they were converted from a 2 character hexadecimal
        self.red = UInt8(red)
        self.green = UInt8(green)
        self.blue = UInt8(blue)
    }
}
