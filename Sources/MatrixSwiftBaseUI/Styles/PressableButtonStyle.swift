import SwiftUI

public struct PressableButtonStyle: ButtonStyle {
    let scaledAmount: CGFloat

    public init(scaledAmount: CGFloat = 0.9) {
        self.scaledAmount = scaledAmount
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaledAmount : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
    }
}

extension View {
    public func withPressableStyle(scaledAmount: CGFloat = 0.9) -> some View {
        buttonStyle(PressableButtonStyle(scaledAmount: scaledAmount))
    }
}
