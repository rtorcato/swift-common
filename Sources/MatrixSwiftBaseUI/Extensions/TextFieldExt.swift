//
//  TextFieldExtension.swift
//  MatrixBaseAppleApp
//
//  Created by Richard Torcato on 2021-06-07.
//

import SwiftUI

#if os(macOS)
// Hide Focus Ring for mac
extension NSTextField {
    override open var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
#endif
