//
//  FilamentMaterialRow.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct FilamentMaterialRow: View {
    let material: String
    
    var body: some View {
        Text(material)
    }
}

struct FilamentMaterialRow_Previews: PreviewProvider {
    static var previews: some View {
        FilamentMaterialRow(material: "PLA")
    }
}
