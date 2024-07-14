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
    @Environment(\.editMode)
    private var editMode: Binding<EditMode>?
    
    @State private var editingMaterial: FilamentMaterial?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($userData.materials) { $material in
                    Text(material.name)
                    // TODO: Add swipe action for editing and context menu action for delete
                        .contextMenu {
                            NavigationLink {
                                EditMaterialView(viewModel: .init(material: $material))
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                }
                .onDelete(perform: deleteMaterials)
                .onMove(perform: moveMaterials)
            }
            .navigationTitle("Materials")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        let newMaterial = FilamentMaterial(name: "")
                        userData.materials.append(newMaterial)
                        self.editingMaterial = newMaterial
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(item: $editingMaterial) { material in
            if let materialIndex = userData.materials.firstIndex(where: \.id, equals: material.id) {
                EditMaterialView(viewModel: .init(material: $userData.materials[materialIndex]))
            }
        }
    }
    
    func deleteMaterials(at indexSet: IndexSet) {
        userData.materials.remove(atOffsets: indexSet)
        userData.save()
    }
    
    func moveMaterials(at indices: IndexSet, by offset: Int) {
        userData.materials.move(fromOffsets: indices, toOffset: offset)
        userData.save()
    }
}

struct MaterialsView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialsView()
    }
}
