//
//  SwiftUIView.swift
//  
//
//  Created by Richard Torcato on 2022-12-27.
//

import SwiftUI

struct FormWrapper: View {
    enum FocusedField {
        case int, dec
    }
    @State private var intNumberString = ""
    @State private var decNumberString = ""
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        VStack {
            TextField("Enter Integer Number", text: $intNumberString)
                .focused($focusedField, equals: .int)
            #if os(iOS)
                .numbersOnly($intNumberString)
            #endif
            TextField("Enter Decimal Number", text: $decNumberString)
                .focused($focusedField, equals: .dec)
#if os(iOS)
                .numbersOnly($decNumberString, includeDecimal: true)
#endif
            Spacer()
        }
#if os(iOS)
        .textFieldStyle(.roundedBorder)
        #endif
        .frame(width: 200)
        .toolbar {
#if os(iOS)
            ToolbarItem(placement: .keyboard) {
                Spacer()
            }

            ToolbarItem(placement: .keyboard) {
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
#endif
        }
        .onAppear {
            #if os(iOS)
            UITextField.appearance().clearButtonMode = .whileEditing
            #endif
        }
    }
}

struct FormWrapper_Previews: PreviewProvider {
    static var previews: some View {
        FormWrapper()
    }
}
