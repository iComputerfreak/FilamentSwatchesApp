//
//  HomeView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct HomeView: View {
    @State private var presentedSwatch: Swatch?
    @EnvironmentObject private var userData: UserData
    
    var body: some View {
        NavigationStack {
            VStack {
                ReadNFCButton(presentedSwatch: $presentedSwatch)
                SubtitleView("Recent Scans")
                List {
                    ForEach(userData.swatches) { swatch in
                        SwatchRow(swatch: swatch)
                    }
                }
            }
            .sheet(item: $presentedSwatch) { swatch in
                SwatchView(swatch: swatch)
            }
            .navigationTitle(Text("Home"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
