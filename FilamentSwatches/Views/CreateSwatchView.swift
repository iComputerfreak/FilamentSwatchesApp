//
//  CreateSwatchView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

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
                        ColorPicker(
                            "Color",
                            selection: Binding(
                                get: {
                                    swatch.color?.color ?? .clear
                                },
                                set: { newColor in
                                    // If the new color is transparent, remove the color from the swatch
                                    if newColor.cgColor?.alpha == 0 {
                                        swatch.color = nil
                                    }
                                    if let components = newColor.cgColor?.components,
                                       components.count >= 3 {
                                        swatch.color?.red = UInt8(round(components[0] * 255))
                                        swatch.color?.green = UInt8(round(components[1] * 255))
                                        swatch.color?.blue = UInt8(round(components[2] * 255))
                                    }
                                }
                            ),
                            supportsOpacity: false
                        )
                    }
                }
                
                Section(header: Text("Custom Attributes")) {
                    ForEach(Array(swatch.attributes.keys), id: \.self) { key in
                        HStack {
                            TextField("Attribute", text: Binding(
                                get: {
                                    key
                                },
                                set: { newValue in
                                    let oldValue = swatch.attributes[key]
                                    swatch.attributes.removeValue(forKey: key)
                                    swatch.attributes[newValue] = oldValue ?? ""
                                }
                            ))
                            TextField("Value", text: Binding(
                                get: {
                                    swatch.attributes[key] ?? ""
                                },
                                set: { newValue in
                                    swatch.attributes[key] = newValue
                                }
                            ))
                        }
                    }
                    Button("Add Attribute") {
                        swatch.attributes[""] = ""
                    }
                }
            }
            .navigationTitle(isEditing ? Text("Edit Swatch") : Text("Create Swatch"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isEditing {
                            guard let index = userData.swatches.firstIndex(where: { $0.id == swatch.id }) else {
                                print("Error: editing a swatch that does not exist.")
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
