//
//  PopupButton.swift
//  Example
//
//  Created by Alex.M on 19.05.2022.
//

import SwiftUI
#if os(iOS)
struct PopupButton<Content: View>: View {
    @Binding var isShowing: Bool
    
    var hideAll: () -> Void
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        Button {
            hideAll()
            isShowing.toggle()
        } label: {
            HStack {content()}
        }
//        .customButtonStyle(foreground: .black, background: .clear)
        .buttonStyle(.borderedProminent)
    }
}
#endif
