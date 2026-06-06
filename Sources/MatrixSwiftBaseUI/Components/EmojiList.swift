//
//  SwiftUIView.swift
//  
//
//  Created by Richard Torcato on 2023-02-17.
//

import SwiftUI

#if !os(watchOS) && !os(tvOS)
struct EmojiList: View {
    let columns = [GridItem(.adaptive(minimum: 75.00), spacing: 10)]
    var body: some View {
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0x1f600...0x1f679, id: \.self) { value in
                    GroupBox {
                        VStack {
                            Text("\(emoji(value))")
                                .font(.largeTitle)
                                .fixedSize()
                            Text(String(format: "%", value))
                                .fixedSize()
                        }
                    }
                }
            }
        }
    }
    private func emoji(_ value: Int) -> String {
        guard let scalar = UnicodeScalar(value) else { return "?" }
        return String(Character(scalar))
    }
}

struct EmojiList_Previews: PreviewProvider {
    static var previews: some View {
        EmojiList()
    }
}
#endif
