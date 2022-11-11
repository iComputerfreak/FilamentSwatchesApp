//
//  LibraryView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct LibraryView: View {
    @State private var selectedSwatch: Swatch?
    @State private var editingSwatch: Swatch?
    @EnvironmentObject private var userData: UserData
    
    @State private var addSheetShowing = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(userData.materials, id: \.self) { material in
                    let swatches = userData.swatches.filter { $0.material == material }
                    if !swatches.isEmpty {
                        Section(header: Text(material)) {
                            ForEach(swatches) { swatch in
                                Button {
                                    self.selectedSwatch = swatch
                                } label: {
                                    SwatchRow(swatch: swatch)
                                }
                                .tint(.primary)
                                .contextMenu {
                                    Button {
                                        self.editingSwatch = swatch
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                }
                            }
                            .onDelete { self.deleteSwatches(at: $0, from: swatches) }
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar {
                Button {
                    self.addSheetShowing = true
                } label: {
                    Image(systemName: "plus")
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
        .sheet(item: $editingSwatch) { swatch in
            if let swatch {
                CreateSwatchView(editing: swatch)
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
