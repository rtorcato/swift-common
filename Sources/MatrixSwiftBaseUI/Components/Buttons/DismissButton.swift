//
//  DismissButton.swift
//  DropWallet
//
//  Created by Richard Torcato on 2023-01-04.
//

import SwiftUI

struct DismissButton: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.palette)
            #if os(iOS)
            .foregroundStyle( .secondary, .clear, Color(uiColor: .systemGray5))
            #elseif os(macOS)
            .foregroundStyle( .secondary, .clear, Color(nsColor: .lightGray))
            #endif
        }
        .buttonStyle(.borderless)
        .opacity(0.8)
        .font(.title)
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            DismissButton()
                .padding()
//                .foregroundColor(.white)
        }
        .background(Color.green)
    }
}
