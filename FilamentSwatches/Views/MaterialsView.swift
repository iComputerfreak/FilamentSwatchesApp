//
//  MaterialsView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct MaterialsView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.editMode)
    private var editMode: Binding<EditMode>?
    
    @State private var addSheetShowing: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(userData.materials, id: \.self) { material in
                    Text(material)
                        .contextMenu {
                            NavigationLink {
                                let index = userData.materials.firstIndex(of: material)!
                                CreateMaterialView(editing: material, at: index)
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
                        self.addSheetShowing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $addSheetShowing) {
            CreateMaterialView()
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
