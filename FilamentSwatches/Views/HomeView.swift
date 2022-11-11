//
//  HomeView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct HomeView: View {
    @State private var presentedSwatch: Swatch?
    @State private var selectedSwatch: Swatch?
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        NavigationStack {
            VStack {
                ReadNFCButton(presentedSwatch: $presentedSwatch)
                SubtitleView("Recent Scans")
                List(selection: $selectedSwatch) {
                    ForEach(userData.swatchHistory) { swatch in
                        SwatchRow(swatch: swatch)
                            .tag(swatch)
                    }
                    .onDelete(perform: deleteHistoryItems)
                }
            }
            .navigationTitle(Text("Home"))
        }
        .sheet(item: $presentedSwatch) { swatch in
            SwatchView(swatch: swatch)
        }
        .sheet(item: $selectedSwatch) { swatch in
            if let swatch {
                SwatchView(swatch: swatch)
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
