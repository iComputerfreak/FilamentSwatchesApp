// Copyright © 2024 Jonas Frey. All rights reserved.

import AppFoundation
import SwiftUI

struct SwatchRow: StatefulView {
    @State var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.swatch.descriptiveName)
                .font(.title3)
                .bold()
            Spacer()
            colorSample
        }
        .tint(.primary)
        .swipeActions(allowsFullSwipe: true) {
            deleteSwatchButton
            editSwatchButton
        }
    }
    
    private var colorSample: some View {
        viewModel.swatch.color?.color
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    private var deleteSwatchButton: some View {
        Button {
            viewModel.deleteSwatch()
        } label: {
            Label("Delete", systemImage: "trash")
        }
        .tint(.red)
    }
    
    private var editSwatchButton: some View {
        Button {
            viewModel.editSwatch()
        } label: {
            Label("Edit", systemImage: "pencil")
        }
    }
}

#Preview {
    SwatchRow(
        viewModel: .init(
            swatch: SampleData.swatch,
            editingSwatch: .constant(nil)
        )
    )
}
