//
//  TextEditorOld.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-28.
//
import SwiftUI

// if #available(iOS 14.0, *) {
//  TextEditor(text: $noteData.noteText)
// } else {
//  // Fallback on earlier versions
// }

// struct TextEditor: UIViewRepresentable {
//    @Binding var text: String
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> UITextView {
//        let textView = UITextView()
//        textView.delegate = context.coordinator
//
//
//        textView.isEditable = true
//        textView.isScrollEnabled = true
//        textView.backgroundColor = UIColor.white
//
//        textView.isUserInteractionEnabled = true
//        textView.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
//
//        return textView
//    }
//
//    func updateUIView(_ uiView: UITextView, context: Context) {
//        uiView.text = text
//    }
//
//    class Coordinator: NSObject, UITextViewDelegate {
//        var parent: TextEditor
//
//        init(_ textView: TextEditor) {
//            self.parent = textView
//        }
//
//        func textView(
//            _ textView: UITextView,
//            shouldChangeTextIn range: NSRange,
//            replacementText text: String
//        ) -> Bool {
//            return true
//        }
//
//        func textViewDidChange(_ textView: UITextView) {
//            self.parent.text = textView.text
//        }
//    }
// }
//
// struct TextEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        TextEditor(text: .constant("placeholder text"))
//    }
// }
