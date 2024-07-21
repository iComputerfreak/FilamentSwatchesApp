//
//  EditSwatchView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import DependencyInjection
import Logging
import SwiftUI

struct EditSwatchView: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction
    
    @State var viewModel: ViewModel
    
    /// Create new swatch
    init(viewModel: ViewModel) { // swiftlint:disable:this type_contents_order
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            Form {
                materialPicker
                
                // TODO: Create custom view for the TextField + label
                TextField("(required)", text: $viewModel.brand)
                    .leadingLabel("Brand")
                TextField("(optional)", text: $viewModel.productLine)
                    .leadingLabel("Product Line")
                TextField("(required)", text: $viewModel.colorName)
                    .leadingLabel("Color Name")
                TemperatureTextField("Extruder Temp", value: $viewModel.extruderTemp)
                TemperatureTextField("Bed Temp", value: $viewModel.bedTemp)
                
                Section(header: Text("Color")) {
                    Toggle("Use Color?", isOn: $viewModel.isShowingColorPicker)
                    if viewModel.isShowingColorPicker {
                        ColorPicker(
                            "Color",
                            selection: $viewModel.swatchColor,
                            supportsOpacity: true
                        )
                    }
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    submitButton
                }
            }
        }
    }
    
    private var materialPicker: some View {
        Picker("Material", selection: $viewModel.material) {
            Text("Select...")
                .disabled(true)
                .tag(FilamentMaterial(name: ""))
            ForEach(viewModel.materials) { material in
                Text(material.name)
                    .tag(material)
            }
        }
    }
    
    private var submitButton: some View {
        Button {
            viewModel.submit()
            dismiss()
        } label: {
            Text("Save")
                .bold()
        }
        .disabled(!viewModel.isFormValid)
    }
}

struct CreateSwatchView_Previews: PreviewProvider {
    static var previews: some View {
        EditSwatchView(viewModel: .init(swatch: SampleData.swatch, title: "Create Swatch"))
    }
}
