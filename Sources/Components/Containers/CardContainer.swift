//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-02-14.
//

import SwiftUI

public struct CardContainer<Content: View>: View {
    var alignment: Alignment = .topLeading
    var cornerRadius: CGFloat = 10
    var strokeLineWidth: Int = 1
    var strokeColor: Color = Color.black
    @ViewBuilder var content: () -> Content
    
    public var body: some View {
        HStack {
            content()
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .cornerRadius(cornerRadius)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, lineWidth: CGFloat(strokeLineWidth))
            )
    }
}

struct CardContainer_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CardContainer {
                VStack {
                    Color.red
                        .frame(height: 400)
//                    Image("post2")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("SwiftUI")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text("Drawing a Border with Rounded Corners")
                                .font(.title)
                                .fontWeight(.black)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                            Text("Written by Simon Ng".uppercased())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .layoutPriority(100)
                        Spacer()
                    }
                    .padding()
                }
            }
        }.padding()
    }
}
