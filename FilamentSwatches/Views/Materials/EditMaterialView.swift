//
//  CreateMaterialView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import DependencyInjection
import SwiftUI

struct EditMaterialView: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction
    
    @State private var viewModel: ViewModel
    
    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Name", text: $viewModel.name)
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar { toolbarContent }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            saveButton
        }
        ToolbarItem(placement: .topBarLeading) {
            cancelButton
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            viewModel.save()
            dismiss()
        }
        .disabled(!viewModel.isFormValid)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
}

struct CreateMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        EditMaterialView(
            viewModel: .init(
                material: .init(name: "PLA"),
                title: "Edit Material"
            )
        )
    }
}
