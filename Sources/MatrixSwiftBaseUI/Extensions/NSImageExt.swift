//
//  File.swift
//  
//
//  Created by Richard Torcato on 2023-01-13.
//
#if os(macOS)
import Cocoa

// Step 1: Typealias UIImage to NSImage
public typealias UIImage = NSImage

// Step 2: You might want to add these APIs that UIImage has but NSImage doesn't.
extension NSImage {
    public var cgImage: CGImage? {
        var proposedRect = CGRect(origin: .zero, size: size)

        return cgImage(forProposedRect: &proposedRect,
                       context: nil,
                       hints: nil)
    }

//    public convenience init?(named name: String) {
//        self.init(named: Name(name))
//    }
}
#endif
