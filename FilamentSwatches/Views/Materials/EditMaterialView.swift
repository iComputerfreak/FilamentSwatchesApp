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
    
    @Bindable private var viewModel: ViewModel
    
    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $viewModel.name)
            }
            .navigationTitle(Text("Edit Material"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            viewModel.save()
            dismiss()
        }
        .disabled(!viewModel.isValid)
    }
}

struct CreateMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        EditMaterialView(viewModel: .init(material: .constant(.init(name: "PLA"))))
    }
}
