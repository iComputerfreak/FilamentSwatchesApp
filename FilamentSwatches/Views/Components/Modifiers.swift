//
//  Modifiers.swift
//  FilamentSwatches
//
//  Created by Jonas Frey on 10.11.22.
//

import Foundation
import SwiftUI


extension View {
    func bigProminentButtonStyle() -> some View {
        self
        .foregroundColor(.white)
        .font(.title)
        .padding(.vertical, 20)
        .padding(.horizontal, 40)
        .background(
            LinearGradient(
                colors: [.blue, .indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .clipShape(RoundedRectangle(cornerRadius: 8))
        )
    }
}
