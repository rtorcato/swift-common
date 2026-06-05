//
//  LazyView.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-12-02.
//

import SwiftUI

public struct LazyView <T: View>: View {
    var view: () -> T
    
    public var body: some View {
        self.view()
    }
}
