//
//  RotatingBall.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-12-12.
//

import SwiftUI

public struct RotatingBall: View {
    @State var isAnimating = false // <1>
    var animation: Animation {
       Animation.linear.repeatForever(autoreverses: false)
    }
    public var body: some View {
        Rectangle()
            .fill(Color.pink)
            .frame(width: 100, height: 100)
//            .scaleEffect(self.isAnimating ? 0.5: 1)
            .rotationEffect(.degrees(self.isAnimating ? -360: 1), anchor: .center)
//            .animation(Animation.linear(duration: 1))
            .animation(Animation.linear(duration: 5).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                self.isAnimating = true // <2>
            }
    }
}

struct RotatingBall_Previews: PreviewProvider {
    static var previews: some View {
        RotatingBall()
    }
}
