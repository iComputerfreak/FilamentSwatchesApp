//
//  SubtitleView.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 07.11.22.
//

import SwiftUI

public struct SubtitleView: View {
    let text: LocalizedStringKey
    
    // swiftlint:disable:next type_contents_order
    public init(_ text: LocalizedStringKey) {
        self.text = text
    }
    
    public var body: some View {
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
