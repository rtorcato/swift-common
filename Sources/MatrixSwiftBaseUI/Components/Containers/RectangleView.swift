//
//  RectangleView.swift
//  DropWallet
//
//  Created by Richard Torcato on 2023-01-24.
//

import SwiftUI

struct RectangleView: View {
    var cornerRadius: CGFloat
    var fillColor: Color = .clear
    var cornerStyle: RoundedCornerStyle = .circular
    var strokeColor: Color = .black
    var strokeLineWidth: CGFloat?
    
    var body: some View {
        ZStack {
            RoundedRectangle(
                cornerRadius: cornerRadius,
                style: cornerStyle
            )
            .fill(fillColor)
            if let strokeLineWidth = strokeLineWidth {
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: cornerStyle
                ).stroke(strokeColor, lineWidth: strokeLineWidth)
            }
        }
    }
}

struct RectangleView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleView(cornerRadius: 20, strokeColor: .black, strokeLineWidth: 10)
            .padding()
    }
}
