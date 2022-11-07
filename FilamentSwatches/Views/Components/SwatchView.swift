//
//  SwatchView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct SwatchView: View {
    let swatch: Swatch
    
    var body: some View {
        ZStack {
            swatch.color?.color
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(swatch.descriptiveName)
                    .font(.largeTitle.bold())
                    .padding(.bottom)
                SwatchViewRow(key: "Material", value: swatch.material?.name ?? "")
                SwatchViewRow(key: "Brand", value: swatch.brand)
                if let productLine = swatch.productLine {
                    SwatchViewRow(key: "Product Line", value: productLine)
                }
                SwatchViewRow(key: "Color", value: swatch.colorName)
                if let extruderTemp = swatch.extruderTemp {
                    SwatchViewRow(key: "Extruder Temp", value: "\(extruderTemp) °C")
                }
                if let bedTemp = swatch.bedTemp {
                    SwatchViewRow(key: "Bed Temp", value: "\(bedTemp) °C")
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .padding()
        }
    }
}

private struct SwatchViewRow: View {
    let key: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack {
            Text(key)
                .bold()
            Spacer()
            Text(value)
        }
        .font(.title2)
    }
}

struct SwatchView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                SwatchView(swatch: SampleData.swatch)
            }
    }
}
