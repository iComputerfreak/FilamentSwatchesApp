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
                // MARK: Card
                VStack {
                    Text(swatch.descriptiveName)
                        .font(.largeTitle.bold())
                        .padding(.bottom)
                    SwatchViewRow(key: "Material", value: swatch.material)
                    SwatchViewRow(key: "Brand", value: swatch.brand)
                    if !swatch.productLine.isEmpty {
                        SwatchViewRow(key: "Product Line", value: swatch.productLine)
                    }
                    SwatchViewRow(key: "Color", value: swatch.colorName)
                    if swatch.extruderTemp > 0 {
                        SwatchViewRow(key: "Extruder Temp", value: "\(swatch.extruderTemp) °C")
                    }
                    if swatch.bedTemp > 0 {
                        SwatchViewRow(key: "Bed Temp", value: "\(swatch.bedTemp) °C")
                    }
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
                .padding()
                
                // MARK: Write Button
                WriteNFCButton(swatch: swatch)
                
                // MARK: Add to Library Button
                if !userData.swatches.contains(where: { $0.id == swatch.id }) {
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
                    .environmentObject(SampleData.userData)
            }
    }
}
