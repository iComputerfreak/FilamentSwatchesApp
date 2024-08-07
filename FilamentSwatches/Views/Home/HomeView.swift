//
//  HomeView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import AppFoundation
import AppUI
import SwiftUI

struct HomeView: StatefulView {
    @State var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ReadNFCButton(viewModel: .init())
                SubtitleView("Recent Scans")
                List(selection: $viewModel.presentedSwatch) {
                    ForEach(viewModel.swatchHistory) { swatch in
                        SwatchRow(
                            viewModel: .init(
                                swatch: swatch,
                                // TODO: Make editable (move sheets into SwatchRow)
                                editingSwatch: .constant(nil)
                            )
                        )
                        .tag(swatch)
                    }
                    .onDelete(perform: viewModel.deleteHistoryItems)
                }
            }
            .navigationTitle(Text("Home"))
        }
        .sheet(item: $viewModel.presentedSwatch) { swatch in
            SwatchView(viewModel: .init(swatch: swatch))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
    }
}
