//
//  LibraryView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import AppFoundation
import SwiftUI

struct LibraryView: StatefulView {
    @State var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.materials) { (material: FilamentMaterial) in
                    let swatches = viewModel.swatches(for: material)
                    if !swatches.isEmpty {
                        Section(header: Text(material.name)) {
                            ForEach(swatches) { swatch in
                                SwatchRow(
                                    viewModel: .init(
                                        swatch: swatch,
                                        editingSwatch: $viewModel.editingSwatch,
                                        selectedSwatch: $viewModel.selectedSwatch
                                    )
                                )
                            }
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar { toolbarContent }
        }
        .sheet(isPresented: $viewModel.isShowingAddSwatchSheet) {
            CreateSwatchView()
        }
        .sheet(item: $viewModel.selectedSwatch) { swatch in
            SwatchView(swatch: swatch)
        }
        .sheet(item: $viewModel.editingSwatch) { swatch in
            CreateSwatchView(editing: swatch)
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            addSwatchButton
        }
    }
    
    private var addSwatchButton: some View {
        Button {
            viewModel.isShowingAddSwatchSheet = true
        } label: {
            Image(systemName: "plus")
        }
        .accessibilityLabel("add-swatch")
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(viewModel: .init())
            .environmentObject(SampleData.previewUserData)
    }
}
