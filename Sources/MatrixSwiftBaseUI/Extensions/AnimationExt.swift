//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-12.
//

import SwiftUI

extension AnyTransition {
    //    static var slide: AnyTransition {
    //            AnyTransition.slide
    //    }
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

extension Animation {
    static func ripple(index: Int = Int(0.5)) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(2)
            .delay(0.03 * Double(index))
    }
}
