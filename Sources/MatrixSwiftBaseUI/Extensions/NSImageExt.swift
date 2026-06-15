//
//  NSImageExt.swift
//  MatrixSwiftBase
//

#if os(macOS)
import Cocoa

// Internal cross-platform shim so the rest of the library can refer to
// `UIImage` on every Apple platform. Intentionally `internal` — exposing this
// as `public` would pollute every macOS consumer's top-level namespace and
// collide with their own compat shims.
typealias UIImage = NSImage

extension NSImage {
    /// Bridge for the `UIImage.cgImage` property that `NSImage` doesn't ship.
    public var cgImage: CGImage? {
        var proposedRect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &proposedRect, context: nil, hints: nil)
    }
}
#endif
