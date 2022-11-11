//
//  MaterialsView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct MaterialsView: View {
    @EnvironmentObject private var userData: UserData
    @Environment(\.editMode) private var editMode
    
    @State private var addSheetShowing = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(userData.materials, id: \.self) { material in
                    if editMode?.wrappedValue.isEditing ?? false {
                        NavigationLink {
                            let index = userData.materials.firstIndex(of: material)!
                            CreateMaterialView(editing: material, at: index)
                        } label: {
                            Text(material)
                        }
                    } else {
                        Text(material)
                    }
                }
                .onDelete(perform: deleteMaterials)
                .onMove(perform: moveMaterials)
            }
            .navigationTitle("Materials")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .environment(\.editMode, self.editMode)
                }
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
