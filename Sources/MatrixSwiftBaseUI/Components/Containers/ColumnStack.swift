//
//  ColumnStack.swift
//
//  Created by Richard Torcato on 2023-02-09.
//

import SwiftUI

public struct ColumnStack<Content: View>: View {
    @ViewBuilder var content: () -> Content
    var alignment: Alignment = .topLeading
    
    public var body: some View {
        VStack {
            content()
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}

struct ColumnStack_Previews: PreviewProvider {
    static var previews: some View {
        ColumnStack {
            Text("Hello")
        }
        .frame(width: 200)
        .background(.red)
    }
}
