//
//  SwatchView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct SwatchView: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction
    
    @State var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                viewModel.swatch.color?.color
                    .ignoresSafeArea()
                
                VStack {
                    // MARK: Card
                    infoCard
                        .padding()
                    
                    // MARK: Write Button
                    WriteNFCButton(swatch: viewModel.swatch)
                    
                    // MARK: Add to Library Button
                    addToLibraryButton
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    DismissButton()
                }
            }
        }
    }
    
    private var infoCard: some View {
        VStack {
            // Name
            Text(viewModel.swatch.descriptiveName)
                .font(.largeTitle.bold())
                .padding(.bottom)
            
            SwatchViewRow(key: "Material", value: viewModel.swatch.material)
            SwatchViewRow(key: "Brand", value: viewModel.swatch.brand)
            if !viewModel.swatch.productLine.isEmpty {
                SwatchViewRow(key: "Product Line", value: viewModel.swatch.productLine)
            }
            SwatchViewRow(key: "Color", value: viewModel.swatch.colorName)
            if viewModel.swatch.extruderTemp > 0 {
                SwatchViewRow(key: "Extruder Temp", value: "\(viewModel.swatch.extruderTemp) °C")
            }
            if viewModel.swatch.bedTemp > 0 {
                SwatchViewRow(key: "Bed Temp", value: "\(viewModel.swatch.bedTemp) °C")
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
    
    @ViewBuilder
    private var addToLibraryButton: some View {
        if !viewModel.isInLibrary {
            Button("Add to Library") {
                viewModel.addToLibrary()
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigo)
        }
    }
}

struct SwatchView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true)) {
                SwatchView(viewModel: .init(swatch: SampleData.swatch))
            }
    }
}
