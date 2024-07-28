// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftUI

public extension View {
    // TODO: Should be a proper view
    @ViewBuilder
    func leadingLabel(_ label: LocalizedStringKey) -> some View {
        HStack {
            Text(label)
            Spacer()
            self
                .multilineTextAlignment(.trailing)
        }
    }
}
