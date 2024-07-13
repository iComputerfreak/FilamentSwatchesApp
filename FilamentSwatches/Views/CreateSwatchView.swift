//
//  CreateSwatchView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import DependencyInjection
import Logging
import SwiftUI

// TODO: Move out
extension View {
    @ViewBuilder
    func leadingLabel(_ label: LocalizedStringKey) -> some View {
        HStack {
            Text(label)
            Spacer()
            self
                .multilineTextAlignment(.trailing)
        }
    }
}

struct CreateSwatchView: View {
    @State private var swatch: Swatch = Self.createNewSwatch()
    @State private var isEditing = false
    @EnvironmentObject private var userData: UserData
    @Environment(\.dismiss) private var dismiss
    
    @Injected private var logger: Logger
    
    /// Create new swatch
    init() {}
    
    /// Edit existing swatch
    init(editing swatch: Swatch) {
        self.init()
        self.swatch = swatch
        self.isEditing = true
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Material", selection: $swatch.material) {
                    Text("Select...")
                        .disabled(true)
                        .tag("")
                    ForEach(userData.materials, id: \.self) { material in
                        Text(material)
                    }
                }
                TextField("(required)", text: $swatch.brand)
                    .leadingLabel("Brand")
                TextField("(optional)", text: $swatch.productLine)
                    .leadingLabel("Product Line")
                TextField("(required)", text: $swatch.colorName)
                    .leadingLabel("Color Name")
                TemperatureTextField("Extruder Temp", value: $swatch.extruderTemp)
                TemperatureTextField("Bed Temp", value: $swatch.bedTemp)
                
                Section(header: Text("Color")) {
                    Toggle("Use Color?", isOn: Binding(get: {
                        swatch.color != nil
                    }, set: { newValue in
                        // Don't use color
                        if newValue == false {
                            swatch.color = nil
                        } else {
                            // Use color (create, if nil)
                            if swatch.color == nil {
                                swatch.color = .init(red: 255, green: 255, blue: 255)
                            }
                        }
                    }))
                    if swatch.color != nil {
                        ColorPicker("Color", selection: Binding(get: {
                            swatch.color?.color ?? .clear
                        }, set: { newColor in
                            // If the new color is transparent, remove the color from the swatch
                            if newColor.cgColor?.alpha == 0 {
                                
                            }
                            if let components = newColor.cgColor?.components, components.count >= 3 {
                                swatch.color?.red = UInt8(round(components[0] * 255))
                                swatch.color?.green = UInt8(round(components[1] * 255))
                                swatch.color?.blue = UInt8(round(components[2] * 255))
                            }
                        }), supportsOpacity: false)
                    }
                }
            }
            .navigationTitle(isEditing ? Text("Edit Swatch") : Text("Create Swatch"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isEditing {
                            guard let index = userData.swatches.firstIndex(where: { $0.id == swatch.id }) else {
                                logger.error("Trying to edit swatch \(swatch) that does not exist.")
                                return
                            }
                            // Replace with the edited swatch
                            userData.swatches[index] = swatch
                        } else {
                            userData.swatches.append(swatch)
                        }
                        userData.save()
                        dismiss()
                    }
                    .disabled(!swatch.isValid)
                }
            }
        }
    }
    
    static func createNewSwatch() -> Swatch {
        return Swatch(
            material: "",
            brand: "",
            productLine: "",
            colorName: "",
            color: nil,
            extruderTemp: 200,
            bedTemp: 60
        )
    }
}

struct CreateSwatchView_Previews: PreviewProvider {
    static var previews: some View {
        CreateSwatchView()
            .environmentObject(SampleData.previewUserData)
    }
}
