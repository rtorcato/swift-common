import XCTest
@testable import MatrixSwiftBaseCore

final class LocaleHelperTests: XCTestCase {

    override func tearDown() {
        LocaleHelper.current = .current // reset the runtime override
        super.tearDown()
    }

    func testInspectionForKnownLocale() {
        let us = Locale(identifier: "en_US")
        XCTAssertEqual(LocaleHelper.currencyCode(for: us), "USD")
        XCTAssertEqual(LocaleHelper.languageCode(for: us), "en")
        XCTAssertEqual(LocaleHelper.regionCode(for: us), "US")
    }

    func testRuntimeOverride() {
        LocaleHelper.current = Locale(identifier: "fr_FR")
        XCTAssertEqual(LocaleHelper.currencyCode(), "EUR")
        XCTAssertEqual(LocaleHelper.languageCode(), "fr")
    }

    func testAvailableIdentifiersNotEmpty() {
        XCTAssertFalse(LocaleHelper.availableIdentifiers.isEmpty)
    }

    func testPluralization() {
        XCTAssertEqual(PluralizationHelper.format(1, singular: "file", plural: "files"), "1 file")
        XCTAssertEqual(PluralizationHelper.format(5, singular: "file", plural: "files"), "5 files")
        XCTAssertEqual(PluralizationHelper.format(0, singular: "file", plural: "files"), "0 files")
        XCTAssertEqual(PluralizationHelper.format(0, singular: "file", plural: "files", zero: "no files"), "no files")
    }
}
