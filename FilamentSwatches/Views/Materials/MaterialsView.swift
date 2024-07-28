//
//  MaterialsView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import JFUtils
import SwiftUI

struct MaterialsView: View {
    @State private var viewModel: ViewModel
    
    // swiftlint:disable:next type_contents_order
    init(viewModel: ViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }
    
    // TODO: Adding materials does currently not update the view
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.materials) { material in
                    FilamentMaterialRow(material: material)
                }
            }
            .navigationTitle("Materials")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
        }
        .sheet(
            item: $viewModel.editingMaterial,
            onDismiss: viewModel.onEditMaterialSheetDismiss
        ) { material in
            EditMaterialView(viewModel: .init(material: material, title: "Create Material"))
        }
    }
    
    private var addButton: some View {
        Button {
            viewModel.addMaterial()
        } label: {
            Label("Add", systemImage: "plus")
        }
    }
}

struct MaterialsView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialsView(viewModel: .init())
    }
}
