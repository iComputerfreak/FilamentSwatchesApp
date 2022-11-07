//
//  MaterialsView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct MaterialsView: View {
    @EnvironmentObject private var userData: UserData
    
    @State private var addSheetShowing = false
    
    var body: some View {
        // TODO: EditButton to change names
        NavigationStack {
            List {
                ForEach(userData.materials) { material in
                    // TODO: Make Editable
                    Text(material.name)
                }
            }
            .navigationTitle("Materials")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
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
}

struct MaterialsView_Previews: PreviewProvider {
    static var previews: some View {
        MaterialsView()
    }
}
