//
//  SwiftUIView.swift
//  
//
//  Created by Richard Torcato on 2023-01-03.
//

import SwiftUI
import UniformTypeIdentifiers

#if os(iOS)
struct CopyTextView: View {
    @State private var text: String = ""
    @State private var buttonText  = "Copy"
    private let pasteboard = UIPasteboard.general
    
    var body: some View {
        GroupBox {
            VStack {
                HStack {
                    Text("Label:")
                    Spacer()
                }
                TextField("Insert text here", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .contextMenu {
                        Button {
                            copyToClipboard()
                        } label: {
                            Text("Copy to clipboard")
                            Image(systemName: "doc.on.doc")
                        }
                    }
                HStack(spacing: 10) {
                    Spacer()
                    Button {
                        copyToClipboard()
                    } label: {
                        Label(buttonText, systemImage: "doc.on.doc")
                    }.buttonStyle(.bordered)
                        .foregroundColor(.black)
                    Button {
                        paste()
                    } label: {
                        Label("Paste", systemImage: "doc.on.clipboard")
                    }
                    .buttonStyle(.bordered)  
                    .foregroundColor(.black)
                }.controlSize(.small)
            }
            .padding()
        }.padding()
    }
    
    func paste() {
        if let string = pasteboard.string {
            text = string
        }
    }
    
    func copyToClipboard() {
        pasteboard.string = self.text
        
        self.buttonText = "Copied!"
        // self.text = "" // clear the text after copy
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.buttonText = "Copy to clipboard"
        }
    }
}

struct CopyTextView_Previews: PreviewProvider {
    static var previews: some View {
        CopyTextView()
    }
}
#endif
