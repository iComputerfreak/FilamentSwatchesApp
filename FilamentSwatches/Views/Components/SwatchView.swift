//
//  SwatchView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct SwatchView: View {
    let swatch: Swatch
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        ZStack {
            swatch.color?.color
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Text(swatch.descriptiveName)
                        .font(.largeTitle.bold())
                        .padding(.bottom)
                    SwatchViewRow(key: "Material", value: swatch.material)
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
                
                // MARK: Add to Library Button
                if !userData.swatches.contains { $0.id == swatch.id } {
                    Button("Add to Library") {
                        userData.swatches.append(swatch)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
            }
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
