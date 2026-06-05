//
//  HamburgerBtn.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-07.
//

import SwiftUI

public struct HamburgerBtn: View {
    @State var isRotating = false
    @State var isHidden = false
    
    public var body: some View {
        VStack(spacing: 14) {
            Rectangle()
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(Angle(degrees: isRotating ? 48: 0), anchor: .leading)
            Rectangle()
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .scaleEffect(x: isHidden ? 0 : 1, y: isHidden ? 0 : 1, anchor: .center)
                .opacity(isHidden ? 0 : 1)
            Rectangle()
                .frame(width: 64, height: 10)
                .cornerRadius(4)
                .rotationEffect(Angle(degrees: isRotating ? -48: 0), anchor: .leading)
        }
        .padding()
        .onTapGesture {
            withAnimation(.interpolatingSpring(stiffness: 300, damping: 15)) {
                isRotating.toggle()
                isHidden.toggle()
            }
        }
    }
}

struct HamburgerBtn_Previews: PreviewProvider {
    static var previews: some View {
        HamburgerBtn()
    }
}
