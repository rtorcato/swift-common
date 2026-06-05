//
//  File.swift
//  
//
//  Created by Richard Torcato on 2022-12-23.
//

import SwiftUI

#if os(iOS)
final actor ImageCache {
    private var cache = [UUID: UIImage]()
    
    func save(image: UIImage, withID id: UUID) {
        cache[id] = image
    }
    
    func getImage(for id: UUID) -> UIImage? {
        cache[id]
    }
}

extension URLCache {
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
#endif

/*
 example usage
 
 let imageCache = ImageCache()
 Task.detached {
    await imageCache.save(image: firstImage, withID: firstImageID)
 Task.detached {
    await imageCache.save(image: secondImage, withID: secondImageID)
 }
 let cachedImage = await imageCache.getImage(for: firstImageID)

 */
