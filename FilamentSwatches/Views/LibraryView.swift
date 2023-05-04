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
                                .swipeActions(allowsFullSwipe: true) {
                                    Button {
                                        userData.swatches.removeAll(where: { $0.id == swatch.id })
                                        userData.save()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                    Button {
                                        self.editingSwatch = swatch
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                }
                            }
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
            SwatchView(swatch: swatch)
        }
        .sheet(item: $editingSwatch) { swatch in
            CreateSwatchView(editing: swatch)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .environmentObject(SampleData.previewUserData)
    }
}
