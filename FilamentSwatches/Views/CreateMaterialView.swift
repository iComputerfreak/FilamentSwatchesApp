//
//  CreateMaterialView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct CreateMaterialView: View {
    @State private var material: String = ""
    @State private var editingIndex: Int = -1
    @State private var isEditing: Bool = false
    
    @EnvironmentObject private var userData: UserData
    @Environment(\.dismiss)
    private var dismiss: DismissAction
    
    var isValid: Bool {
        guard !material.isEmpty else { return false }
        
        // If the material already exists, it is only valid, if we are editing an item and did not rename it yet
        if userData.materials.contains(material) {
            return isEditing && userData.materials[editingIndex] == material
        }
        return true
    }
    
    /// Create a new material
    init() {} // swiftlint:disable:this type_contents_order
    
    /// Edit an existing material
    init(editing material: String, at index: Int) { // swiftlint:disable:this type_contents_order
        self.init()
        self.isEditing = true
        self.editingIndex = index
        self.material = material
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $material)
            }
            .navigationTitle(isEditing ? Text("Edit Material") : Text("Create Material"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if isEditing {
                            userData.materials[editingIndex] = self.material
                        } else {
                            userData.materials.append(material)
                        }
                        userData.save()
                        dismiss()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }
}

struct CreateMaterialView_Previews: PreviewProvider {
    static var previews: some View {
        CreateMaterialView()
    }
}
