//
//  AnimatableFontModifier.swift
//  DesignCodeiOS15
//
//  Created by Meng To on 2021-11-18.
//

import SwiftUI

#if os(iOS)
public struct AnimatableFontModifier: AnimatableModifier {
    var size: Double
    var weight: Font.Weight = .regular
    var design: Font.Design = .default
    
    public var animatableData: Double {
        get { size }
        set { size = newValue }
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: design))
    }
}
#endif
#if os(iOS)
extension View {
    public func animatableFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
    }
}
#endif
