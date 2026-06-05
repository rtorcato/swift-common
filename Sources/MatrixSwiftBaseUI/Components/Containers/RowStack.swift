//
//  RowStack.swift
//
//  Created by Richard Torcato on 2023-02-09.
//

import SwiftUI

public struct RowStack<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var alignment: Alignment = .topLeading
    
//    init(alignment: Alignment = .topLeading, @ViewBuilder _ content: () -> Content) {
//        self.content = content()
//        self.alignment = alignment
//    }
    
    public var body: some View {
        HStack {
            content()
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

struct RowStack_Previews: PreviewProvider {
    static var previews: some View {
        RowStack {
            Text("Hello")
        }
        .frame(height: 100)
        .background(.red)
    }
}
