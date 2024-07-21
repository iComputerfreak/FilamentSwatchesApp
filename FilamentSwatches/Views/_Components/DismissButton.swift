// Copyright © 2024 Jonas Frey. All rights reserved.

import SwiftUI

/// A button that dismisses the currently presented view
struct DismissButton: View {
    @Environment(\.dismiss)
    private var dismiss: DismissAction
    
    let label: LocalizedStringKey
    
    // swiftlint:disable:next type_contents_order
    init(label: LocalizedStringKey = "Done") {
        self.label = label
    }
    
    var body: some View {
        Button(action: dismiss.callAsFunction) {
            Text(label)
                .bold()
        }
    }
}

#Preview {
    DismissButton()
}
