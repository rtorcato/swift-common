//
//  BlurWindow.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-08-26.
//

import SwiftUI
import Foundation

#if os(macOS)
struct BlurWindow: NSViewRepresentable {
    
    let material: NSVisualEffectView.Material = .hudWindow
    let blendingMode: NSVisualEffectView.BlendingMode = .behindWindow

    func makeNSView(context: Context) -> NSVisualEffectView {
        
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        //
        
        view.material = material
        view.blendingMode = blendingMode
        view.state = NSVisualEffectView.State.active
        //
        
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
#endif
