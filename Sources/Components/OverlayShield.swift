//
//  OverlayShield.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-02.
//

import SwiftUI

public struct OverlayShieldView: View {
    public init() {
        
    }
    public var body: some View {
        Color.black
//            .zIndex(1)
            .opacity(0.25)
            .edgesIgnoringSafeArea(.all)
        #if os(iOS)
            .background(.ultraThinMaterial)
        #endif
    }
}

struct OverlayShield_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            OverlayShieldView()
            Text("hello world")
        }
    }
}
