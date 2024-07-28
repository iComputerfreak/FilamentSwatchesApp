// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftUI

struct SwatchViewRow: View {
    let key: LocalizedStringKey
    let value: String
    
    var body: some View {
        HStack {
            Text(key)
                .bold()
            Spacer()
            Text(value)
        }
        .font(.title2)
    }
}

#Preview {
    SwatchViewRow(key: "Brand", value: "Polymaker")
        .padding()
        .background(.gray.tertiary)
}
