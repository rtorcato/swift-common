import XCTest
import Security
@testable import MatrixSwiftBaseCore

final class KeychainManagerTests: XCTestCase {

    private var service = ""
    private let account = "test-account"

    override func setUp() {
        super.setUp()
        // Unique per test so runs never collide with each other or leftover items.
        service = "MatrixSwiftBaseCoreTests.\(UUID().uuidString)"
    }

    override func tearDown() {
        // KeychainManager has no delete API, so clean up through Security directly.
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        SecItemDelete(query as CFDictionary)
        super.tearDown()
    }

    func testSaveThenGetRoundTrips() throws {
        try KeychainManager.savePassword(service: service, account: account, password: "s3cret")
        XCTAssertEqual(try KeychainManager.getPassword(service: service, account: account), "s3cret")
    }

    func testRoundTripPreservesUnicodeAndEmptyPasswords() throws {
        let unicode = "pässwörd-🔐-密码"
        try KeychainManager.savePassword(service: service, account: "unicode", password: unicode)
        XCTAssertEqual(try KeychainManager.getPassword(service: service, account: "unicode"), unicode)

        try KeychainManager.savePassword(service: service, account: "empty", password: "")
        XCTAssertEqual(try KeychainManager.getPassword(service: service, account: "empty"), "")
    }

    func testAccountsUnderTheSameServiceAreIndependent() throws {
        try KeychainManager.savePassword(service: service, account: "a", password: "one")
        try KeychainManager.savePassword(service: service, account: "b", password: "two")
        XCTAssertEqual(try KeychainManager.getPassword(service: service, account: "a"), "one")
        XCTAssertEqual(try KeychainManager.getPassword(service: service, account: "b"), "two")
    }

    func testSavingTheSameItemTwiceThrowsDuplicateEntry() throws {
        try KeychainManager.savePassword(service: service, account: account, password: "first")
        XCTAssertThrowsError(
            try KeychainManager.savePassword(service: service, account: account, password: "second")
        ) { error in
            guard case KeychainManager.KeychainError.duplicateEntry = error else {
                return XCTFail("expected .duplicateEntry, got \(error)")
            }
        }
        // The original value is untouched.
        XCTAssertEqual(try KeychainManager.getPassword(service: service, account: account), "first")
    }

    func testGettingAMissingItemThrowsItemNotFound() {
        XCTAssertThrowsError(try KeychainManager.getPassword(service: service, account: "missing")) { error in
            guard case KeychainManager.KeychainError.unknown(let status) = error else {
                return XCTFail("expected .unknown, got \(error)")
            }
            XCTAssertEqual(status, errSecItemNotFound)
        }
    }
}
