//
//  HomeView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import AppFoundation
import SwiftUI

struct HomeView: StatefulView {
    @State var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ReadNFCButton(presentedSwatch: $viewModel.presentedSwatch)
                SubtitleView("Recent Scans")
                List(selection: $viewModel.presentedSwatch) {
                    ForEach(viewModel.swatchHistory) { swatch in
                        SwatchRow(swatch: swatch)
                            .tag(swatch)
                    }
                    .onDelete(perform: viewModel.deleteHistoryItems)
                }
            }
            .navigationTitle(Text("Home"))
        }
        .sheet(item: $viewModel.presentedSwatch) { swatch in
            SwatchView(swatch: swatch)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .init())
            .environmentObject(SampleData.previewUserData)
    }
}
