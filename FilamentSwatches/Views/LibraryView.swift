//
//  LibraryView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct LibraryView: View {
    @State private var selectedSwatchID: Swatch.ID?
    @EnvironmentObject private var userData: UserData
    
    @State private var addSheetShowing = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSwatchID) {
                ForEach(userData.materials) { material in
                    let swatches = userData.swatches.filter { $0.material == material }
                    if !swatches.isEmpty {
                        Section(header: Text(material.name)) {
                            ForEach(swatches) { swatch in
                                SwatchRow(swatch: swatch)
                                    .tag(swatch.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.addSheetShowing = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        } detail: {
            if let swatch = userData.swatches.first(where: { $0.id == selectedSwatchID }) {
                SwatchView(swatch: swatch)
                    .navigationTitle(swatch.descriptiveName)
            } else {
                Text("Select a swatch.")
                    .navigationTitle("Swatch Info")
            }
        }
        .sheet(isPresented: $addSheetShowing) {
            CreateSwatchView()
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .environmentObject(SampleData.userData)
    }
}
