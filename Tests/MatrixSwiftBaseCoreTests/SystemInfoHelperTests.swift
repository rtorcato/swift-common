import XCTest
@testable import MatrixSwiftBaseCore

final class SystemInfoHelperTests: XCTestCase {

    func testOSNameIsKnown() {
        XCTAssertTrue(["iOS", "macOS", "tvOS", "watchOS"].contains(SystemInfoHelper.osName))
    }

    func testOSVersionHasDots() {
        let version = SystemInfoHelper.osVersion
        XCTAssertFalse(version.isEmpty)
        XCTAssertEqual(version.filter { $0 == "." }.count, 2) // major.minor.patch
    }

    func testLocaleIdentifierNotEmpty() {
        XCTAssertFalse(SystemInfoHelper.localeIdentifier.isEmpty)
    }

    func testDeviceModelNonEmptyWhenPresent() {
        // Nil is acceptable on some platforms; when present it must be non-empty.
        if let model = SystemInfoHelper.deviceModel {
            XCTAssertFalse(model.isEmpty)
        }
    }
}
