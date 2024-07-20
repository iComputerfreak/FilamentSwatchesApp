//
//  MaterialsView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import JFUtils
import SwiftUI

struct MaterialsView: View {
    @EnvironmentObject private var userData: UserData
    
    @State private var viewModel: ViewModel
    
    @State private var editingMaterial: FilamentMaterial?
    
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
        .sheet(item: $editingMaterial) { material in
            EditMaterialView(viewModel: .init(material: material))
            EditMaterialView(viewModel: .init(material: material, title: "Create Material"))
        }
    }
    
    private var addButton: some View {
        Button {
            let newMaterial = FilamentMaterial(name: "")
            userData.materials.append(newMaterial)
            guard let index = userData.materials.firstIndex(of: newMaterial) else { return }
            self.editingMaterial = userData.materials[index]
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
