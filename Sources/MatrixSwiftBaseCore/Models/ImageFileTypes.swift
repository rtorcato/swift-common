//
//  File.swift
//  
//
//  Created by Richard Torcato on 2022-12-29.
//

import Foundation

enum ImageFileTypes: String, CaseIterable {
    case jpeg
    case png
    case gif
    
    var description: String {
        return String(describing: self)
    }
}
