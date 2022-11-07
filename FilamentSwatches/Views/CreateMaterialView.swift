//
//  CreateMaterialView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct CreateMaterialView: View {
    @State private var material: FilamentMaterial = .init(name: "")
    @EnvironmentObject private var userData: UserData
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $material.name)
            }
            .navigationTitle("Create Material")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        userData.materials.append(material)
                        userData.save()
                        dismiss()
                    }
                    .disabled(material.name.isEmpty)
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
