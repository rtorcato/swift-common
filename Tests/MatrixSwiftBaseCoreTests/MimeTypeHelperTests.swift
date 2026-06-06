import XCTest
@testable import MatrixSwiftBaseCore

final class MimeTypeHelperTests: XCTestCase {

    func testMimeTypeForExtensionCommonTypes() {
        XCTAssertEqual(MimeTypeHelper.mimeType(forExtension: "jpg"), "image/jpeg")
        XCTAssertEqual(MimeTypeHelper.mimeType(forExtension: "jpeg"), "image/jpeg")
        XCTAssertEqual(MimeTypeHelper.mimeType(forExtension: "png"), "image/png")
        XCTAssertEqual(MimeTypeHelper.mimeType(forExtension: "pdf"), "application/pdf")
        XCTAssertEqual(MimeTypeHelper.mimeType(forExtension: "json"), "application/json")
    }

    func testMimeTypeForExtensionAcceptsLeadingDot() {
        XCTAssertEqual(MimeTypeHelper.mimeType(forExtension: ".png"), "image/png")
    }

    func testMimeTypeForExtensionIsCaseInsensitive() {
        XCTAssertEqual(MimeTypeHelper.mimeType(forExtension: "PNG"), "image/png")
        XCTAssertEqual(MimeTypeHelper.mimeType(forExtension: "JpG"), "image/jpeg")
    }

    func testMimeTypeForExtensionReturnsNilForUnknown() {
        XCTAssertNil(MimeTypeHelper.mimeType(forExtension: "definitelynotreal"))
        XCTAssertNil(MimeTypeHelper.mimeType(forExtension: ""))
    }

    func testMimeTypeForFilename() {
        XCTAssertEqual(MimeTypeHelper.mimeType(forFilename: "photo.jpg"), "image/jpeg")
        XCTAssertEqual(MimeTypeHelper.mimeType(forFilename: "/path/to/file.PDF"), "application/pdf")
        XCTAssertEqual(MimeTypeHelper.mimeType(forFilename: "archive.tar.gz"), "application/x-gzip")
    }

    func testMimeTypeForFilenameWithoutExtensionReturnsNil() {
        XCTAssertNil(MimeTypeHelper.mimeType(forFilename: "README"))
        XCTAssertNil(MimeTypeHelper.mimeType(forFilename: ""))
    }

    func testPreferredExtensionForMimeType() {
        XCTAssertEqual(MimeTypeHelper.preferredExtension(forMimeType: "image/png"), "png")
        XCTAssertEqual(MimeTypeHelper.preferredExtension(forMimeType: "application/pdf"), "pdf")
    }

    func testPreferredExtensionReturnsNilForUnknownMime() {
        XCTAssertNil(MimeTypeHelper.preferredExtension(forMimeType: "application/x-not-real"))
    }

    func testExtensionsForMimeTypeIncludesPreferred() {
        let exts = MimeTypeHelper.extensions(forMimeType: "image/jpeg")
        XCTAssertTrue(exts.contains("jpeg") || exts.contains("jpg"), "expected jpeg-family extensions, got \(exts)")
    }

    func testExtensionsForMimeTypeEmptyForUnknown() {
        XCTAssertTrue(MimeTypeHelper.extensions(forMimeType: "application/x-not-real").isEmpty)
    }

    func testRoundTripExtensionMimeExtension() {
        let mime = MimeTypeHelper.mimeType(forExtension: "png")
        XCTAssertEqual(mime, "image/png")
        XCTAssertEqual(MimeTypeHelper.preferredExtension(forMimeType: mime ?? ""), "png")
    }

    func testIsImage() {
        XCTAssertTrue(MimeTypeHelper.isImage("image/png"))
        XCTAssertTrue(MimeTypeHelper.isImage("image/jpeg"))
        XCTAssertFalse(MimeTypeHelper.isImage("audio/mpeg"))
        XCTAssertFalse(MimeTypeHelper.isImage("application/x-not-real"))
    }

    func testIsAudio() {
        XCTAssertTrue(MimeTypeHelper.isAudio("audio/mpeg"))
        XCTAssertTrue(MimeTypeHelper.isAudio("audio/wav"))
        XCTAssertFalse(MimeTypeHelper.isAudio("image/png"))
    }

    func testIsVideo() {
        XCTAssertTrue(MimeTypeHelper.isVideo("video/mp4"))
        XCTAssertTrue(MimeTypeHelper.isVideo("video/quicktime"))
        XCTAssertFalse(MimeTypeHelper.isVideo("image/png"))
    }

    func testIsText() {
        XCTAssertTrue(MimeTypeHelper.isText("text/plain"))
        XCTAssertTrue(MimeTypeHelper.isText("text/html"))
        XCTAssertFalse(MimeTypeHelper.isText("image/png"))
    }

    func testKindClassification() {
        XCTAssertEqual(MimeTypeHelper.kind(forMimeType: "image/png"), .image)
        XCTAssertEqual(MimeTypeHelper.kind(forMimeType: "audio/mpeg"), .audio)
        XCTAssertEqual(MimeTypeHelper.kind(forMimeType: "video/mp4"), .video)
        XCTAssertEqual(MimeTypeHelper.kind(forMimeType: "text/plain"), .text)
        XCTAssertEqual(MimeTypeHelper.kind(forMimeType: "application/pdf"), .pdf)
        XCTAssertEqual(MimeTypeHelper.kind(forMimeType: "application/x-not-real"), .other)
    }
}
