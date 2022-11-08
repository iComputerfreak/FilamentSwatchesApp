//
//  HomeView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct HomeView: View {
    @State private var presentedSwatch: Swatch?
    @State private var selectedSwatchID: Swatch.ID?
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        NavigationSplitView {
            VStack {
                ReadNFCButton(presentedSwatch: $presentedSwatch)
                SubtitleView("Recent Scans")
                // TODO: Make links to show swatches
                List(selection: $selectedSwatchID) {
                    ForEach(userData.swatchHistory) { swatch in
                        SwatchRow(swatch: swatch)
                            .tag(swatch.id)
                    }
                    .onDelete(perform: deleteHistoryItems)
                }
            }
            .sheet(item: $presentedSwatch) { swatch in
                SwatchView(swatch: swatch)
            }
            .navigationTitle(Text("Home"))
        } detail: {
            if let swatch = userData.swatchHistory.first(where: { $0.id == selectedSwatchID }) {
                SwatchView(swatch: swatch)
                    .navigationTitle(swatch.descriptiveName)
            } else {
                Text("Select a swatch.")
                    .navigationTitle("Swatch Info")
            }
        }
    }
    
    func deleteHistoryItems(at indexSet: IndexSet) {
        for index in indexSet {
            let swatch = userData.swatchHistory[index]
            userData.swatchHistory.removeAll { $0.id == swatch.id }
        }
        userData.save()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(SampleData.userData)
    }
}
