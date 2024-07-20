//
//  FilamentMaterialRow.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import DependencyInjection
import SwiftUI

struct FilamentMaterialRow: View {
    private var material: FilamentMaterial
    
    @Injected private var userData: UserData
    
    // swiftlint:disable:next type_contents_order
    init(material: FilamentMaterial) {
        self.material = material
    }
    
    var body: some View {
        Text(material.name)
            .swipeActions {
                deleteButton
                editButton
            }
            .contextMenu {
                editButton
                deleteButton
            }
    }
    
    @ViewBuilder
    private var deleteButton: some View {
        Button(role: .destructive) {
            userData.materials.removeAll { other in
                other.id == material.id
            }
            userData.save()
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    @ViewBuilder
    private var editButton: some View {
        NavigationLink {
            EditMaterialView(viewModel: .init(material: material, title: "Edit Material"))
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
}

struct FilamentMaterialRow_Previews: PreviewProvider {
    static var previews: some View {
        FilamentMaterialRow(material: .init(name: "PLA"))
    }
}
