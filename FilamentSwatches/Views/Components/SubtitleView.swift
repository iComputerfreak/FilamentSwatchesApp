//
//  SubtitleView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

struct SubtitleView: View {
    let text: LocalizedStringKey
    
    init(_ text: LocalizedStringKey) {
        self.text = text
    }
    
    var body: some View {
        HStack {
            Text(text)
                .font(.title.bold())
                .padding(.horizontal)
                .padding(.top)
            Spacer()
        }
    }
}

struct SubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        SubtitleView("Recent Scans")
    }
}
