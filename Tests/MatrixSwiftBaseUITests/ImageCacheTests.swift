import XCTest
@testable import MatrixSwiftBaseUI

// `ImageCache` is UIKit-only (`#if os(iOS)` in the source), so these tests do not run
// under host-platform `swift test` on macOS. Run them with `xcodebuild test` against an
// iOS simulator destination.
#if os(iOS)
import UIKit

final class ImageCacheTests: XCTestCase {

    private func makeImage(width: CGFloat) -> UIImage {
        UIGraphicsImageRenderer(size: CGSize(width: width, height: 1)).image { context in
            UIColor.red.setFill()
            context.fill(CGRect(x: 0, y: 0, width: width, height: 1))
        }
    }

    func testMissingIDReturnsNil() async {
        let cache = ImageCache()
        let image = await cache.getImage(for: UUID())
        XCTAssertNil(image)
    }

    func testSaveThenGetReturnsTheSameImage() async {
        let cache = ImageCache()
        let id = UUID()
        let image = makeImage(width: 4)
        await cache.save(image: image, withID: id)
        let cached = await cache.getImage(for: id)
        XCTAssertTrue(cached === image)
    }

    func testSavingAgainReplacesTheImage() async {
        let cache = ImageCache()
        let id = UUID()
        await cache.save(image: makeImage(width: 4), withID: id)
        let replacement = makeImage(width: 8)
        await cache.save(image: replacement, withID: id)
        let cached = await cache.getImage(for: id)
        XCTAssertTrue(cached === replacement)
    }

    func testIDsAreIndependent() async {
        let cache = ImageCache()
        let first = (id: UUID(), image: makeImage(width: 4))
        let second = (id: UUID(), image: makeImage(width: 8))
        await cache.save(image: first.image, withID: first.id)
        await cache.save(image: second.image, withID: second.id)
        let cachedFirst = await cache.getImage(for: first.id)
        let cachedSecond = await cache.getImage(for: second.id)
        XCTAssertTrue(cachedFirst === first.image)
        XCTAssertTrue(cachedSecond === second.image)
    }

    func testConcurrentSavesAreAllRetained() async {
        let cache = ImageCache()
        let ids = (0..<50).map { _ in UUID() }
        await withTaskGroup(of: Void.self) { group in
            for id in ids {
                group.addTask { await cache.save(image: UIImage(), withID: id) }
            }
        }
        for id in ids {
            let cached = await cache.getImage(for: id)
            XCTAssertNotNil(cached)
        }
    }
}
#endif
