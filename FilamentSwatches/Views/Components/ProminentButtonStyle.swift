import Foundation
import SwiftUI

struct ProminentButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
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

extension View {
    func prominentButtonStyle() -> some View {
        self.modifier(ProminentButtonStyle())
    }
}
