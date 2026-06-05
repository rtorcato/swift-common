//
//  Line.swift
//  PurplePumpkinHalloween
//
//  Created by Raphael Cerqueira on 11/11/20.
//
import SwiftUI

#if os(iOS)
public struct Line: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        
        return path
    }
}
#endif
