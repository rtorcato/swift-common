//
//  SwiftUIView.swift
//  
//
//  Created by Richard Torcato on 2023-02-06.
//

import SwiftUI

struct DashedLineExample: View {
    var body: some View {
        DashedLine()
        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
        .frame(height: 1)
    }
}

struct DashedLineExample_Previews: PreviewProvider {
    static var previews: some View {
        DashedLineExample()
    }
}

public struct DashedLine: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
