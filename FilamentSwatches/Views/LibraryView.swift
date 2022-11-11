//
//  LibraryView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct LibraryView: View {
    @State private var selectedSwatch: Swatch?
    @EnvironmentObject private var userData: UserData
    
    @State private var addSheetShowing = false
    
    var body: some View {
        NavigationStack {
            List(selection: $selectedSwatch) {
                ForEach(userData.materials, id: \.self) { material in
                    let swatches = userData.swatches.filter { $0.material == material }
                    if !swatches.isEmpty {
                        Section(header: Text(material)) {
                            ForEach(swatches) { swatch in
                                SwatchRow(swatch: swatch)
                                    .tag(swatch)
                            }
                            .onDelete { self.deleteSwatches(at: $0, from: swatches) }
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
        }
        .sheet(isPresented: $addSheetShowing) {
            CreateSwatchView()
        }
        .sheet(item: $selectedSwatch) { swatch in
            if let swatch {
                SwatchView(swatch: swatch)
            }
        }
    }
    
    func deleteSwatches(at indexSet: IndexSet, from swatches: [Swatch]) {
        for index in indexSet {
            let swatch = swatches[index]
            userData.swatches.removeAll { $0.id == swatch.id }
        }
        userData.save()
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .environmentObject(SampleData.userData)
    }
}
