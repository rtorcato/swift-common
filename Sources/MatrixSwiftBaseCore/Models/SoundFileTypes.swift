//
//  File.swift
//  
//
//  Created by Richard Torcato on 2022-12-29.
//

import Foundation

public enum SoundFileTypes: String, CaseIterable {
    case mp3
    case wav
    case m4a
    
    public var value: String? {
        return String(describing: self)
    }
    public var description: String {
        return String(describing: self)
    }
//    SoundFileTypes.allCases.forEach { soundFileType in
//        print(soundFileType.rawValue)
//    }
}
