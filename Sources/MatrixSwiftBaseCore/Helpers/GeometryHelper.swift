//
//  GeometryHelper.swift
//  MatrixSwiftBase
//
//  Created by Richard Torcato on 2026-06-06.
//

import CoreGraphics
import Foundation

public final class GeometryHelper {

    public init() { }

    /// Euclidean distance between two points.
    public static func distance(from a: CGPoint, to b: CGPoint) -> CGFloat {
        let dx = b.x - a.x
        let dy = b.y - a.y
        return sqrt(dx * dx + dy * dy)
    }

    /// Midpoint of the line segment between two points.
    public static func midpoint(_ a: CGPoint, _ b: CGPoint) -> CGPoint {
        CGPoint(x: (a.x + b.x) / 2, y: (a.y + b.y) / 2)
    }

    /// Geometric center of a rectangle.
    public static func center(of rect: CGRect) -> CGPoint {
        CGPoint(x: rect.midX, y: rect.midY)
    }

    /// Return a copy of the rectangle inset by the same amount on all sides.
    /// Positive amounts shrink; negative amounts expand.
    public static func inset(_ rect: CGRect, by amount: CGFloat) -> CGRect {
        rect.insetBy(dx: amount, dy: amount)
    }

    /// Whether the rectangle fully contains the point (inclusive on edges).
    public static func contains(_ rect: CGRect, point: CGPoint) -> Bool {
        rect.contains(point)
    }

    /// Aspect ratio of the size (width / height). Returns 0 for a zero-height size.
    public static func aspectRatio(_ size: CGSize) -> CGFloat {
        size.height == 0 ? 0 : size.width / size.height
    }
}
