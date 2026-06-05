//
//  AddToWalletButton.swift
//  DropWallet
//
//  Created by Richard Torcato on 2023-01-31.
//

import SwiftUI

#if os(iOS)
import PassKit

public struct AddToWalletButton: View {
    public var body: some View {
        AddPassToWalletButton {
            print("add pass")
        }
    }
}

struct AddToWalletButton_Previews: PreviewProvider {
    static var previews: some View {
        AddToWalletButton()
    }
}
#endif
