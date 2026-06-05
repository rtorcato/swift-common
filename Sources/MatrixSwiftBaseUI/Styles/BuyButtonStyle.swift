//
//  BuyButtonStyle.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-08.
//

import SwiftUI

#if os(iOS)
struct BuyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.accentColor)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.accentColor, lineWidth: 1))
            .opacity(configuration.isPressed ? 0.5 : 1)
        
    }
}

struct BuyButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
       
        VStack {
            Button("3.99 CAD") {
                
            }
            .buttonStyle(BuyButtonStyle())
        }
    }
}
#endif
