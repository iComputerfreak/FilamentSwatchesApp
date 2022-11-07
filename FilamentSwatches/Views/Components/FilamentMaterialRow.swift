//
//  FilamentMaterialRow.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct FilamentMaterialRow: View {
    let material: FilamentMaterial
    
    var body: some View {
        Text(material.name)
    }
}

struct FilamentMaterialRow_Previews: PreviewProvider {
    static var previews: some View {
        FilamentMaterialRow(material: .init(name: "PLA"))
    }
}
