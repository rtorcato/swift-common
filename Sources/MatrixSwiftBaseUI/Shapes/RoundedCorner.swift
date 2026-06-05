//
//  RoundedCorner.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-10-21.
//

import SwiftUI

#if os(iOS)
public struct RoundedCorner: Shape {
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
