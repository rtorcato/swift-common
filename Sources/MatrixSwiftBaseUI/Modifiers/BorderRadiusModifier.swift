//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-18.
//

import SwiftUI

public struct BorderRadiusModifier: ViewModifier {
    @Binding var radius: CGFloat
    @Binding var lineWidth: CGFloat
    @Binding var color: Color
    @Binding var backgroundColor: Color
    
   public func body(content: Content) -> some View {
        content
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(color, lineWidth: lineWidth)
            )
            .background(backgroundColor)
            .cornerRadius(radius)
    }
}

extension View {
    public func borderRadiusModifier(radius: Binding<CGFloat>, lineWidth: Binding<CGFloat>, color: Binding<Color>, backgroundColor: Binding<Color>) -> some View {
        self.modifier(BorderRadiusModifier(radius: radius, lineWidth: lineWidth, color: color, backgroundColor: backgroundColor))
    }
}
