//
//  CardFlip.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-12-07.
//

import SwiftUI

struct CardFlip: View {
    @State private var isFlipped: Bool = false

    var body: some View {
        VStack {
            if isFlipped == true {
                Rectangle()
                    .foregroundColor(.pink)
                    .frame(width: 300, height: 400)
                    .cornerRadius(16)
            } else {
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: 300, height: 400)
                    .cornerRadius(16)
                    
            }
        }
        .rotation3DEffect(Angle(degrees: self.isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 10, y: 10)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.8)) {
                self.isFlipped.toggle()
            }
        }
    }
}

struct CardFlip_Previews: PreviewProvider {
    static var previews: some View {
        CardFlip()
    }
}
