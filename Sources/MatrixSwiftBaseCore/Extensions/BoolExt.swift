//
//  BoolExt.swift
//  AppleCore
//
//  Created by Richard Torcato on 2022-11-03.
//

import Foundation

extension Bool {
    
    /*
     /// example
     `
     struct ContentView: View {
         
         var body: some View {
             Text("Hello, world!")
                 .padding()
                 .if(.iOS13) { view in
                     view.background(Color.red)
                 }
         }
     }`
     */
    static var iOS13: Bool {
        guard #available(iOS 14, *) else {
            // It's iOS 13 so return true.
            return true
        }
        // It's iOS 14 so return false.
        return false
    }
}
