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
            List(selection: $viewModel.selectedSwatch) {
                ForEach(viewModel.materials) { (material: FilamentMaterial) in
                    let swatches = viewModel.swatches(for: material)
                    if !swatches.isEmpty {
                        Section(header: Text(material.name)) {
                            ForEach(swatches) { swatch in
                                SwatchRow(
                                    viewModel: .init(
                                        swatch: swatch,
                                        editingSwatch: $viewModel.editingSwatch
                                    )
                                )
                                .tag(swatch)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Library")
            .toolbar { toolbarContent }
        }
        .sheet(item: $viewModel.selectedSwatch) { swatch in
            SwatchView(viewModel: .init(swatch: swatch))
        }
        .sheet(
            item: $viewModel.editingSwatch,
            onDismiss: viewModel.onEditSwatchSheetDismiss
        ) { swatch in
            EditSwatchView(viewModel: .init(swatch: swatch, title: viewModel.editSwatchTitle))
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
            viewModel.addSwatch()
        } label: {
            Image(systemName: "plus")
        }
        .accessibilityLabel("add-swatch")
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(viewModel: .init())
    }
}
