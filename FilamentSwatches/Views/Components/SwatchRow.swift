//
//  SwatchRow.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct SwatchRow: View {
    let swatch: Swatch
    
    var body: some View {
        HStack {
            Text(swatch.descriptiveName)
                .font(.title3.bold())
            Spacer()
            swatch.color?.color
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}

struct SwatchRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            SwatchRow(swatch: SampleData.swatch)
        }
            .previewLayout(.sizeThatFits)
    }
}
