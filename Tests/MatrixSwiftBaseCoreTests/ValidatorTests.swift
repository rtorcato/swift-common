import XCTest
@testable import MatrixSwiftBaseCore

final class ValidatorTests: XCTestCase {

    func testCreditCardLuhn() {
        let v = CreditCardValidator()
        XCTAssertTrue(v.isValid("4242 4242 4242 4242")) // valid Luhn (spaces ignored)
        XCTAssertTrue(v.isValid("4111111111111111"))
        XCTAssertFalse(v.isValid("4242424242424241")) // last digit tampered
        XCTAssertFalse(v.isValid("1234"))              // too short
    }

    func testPasswordDefaults() {
        let v = PasswordValidator()
        XCTAssertTrue(v.isValid("Abcd1234"))
        XCTAssertFalse(v.isValid("abcd1234"))  // no uppercase
        XCTAssertFalse(v.isValid("Abcdefgh"))  // no digit
        XCTAssertFalse(v.isValid("Ab1"))       // too short
    }

    func testPasswordSpecialCharacterRequirement() {
        let v = PasswordValidator(requirements: .init(requiresSpecialCharacter: true))
        XCTAssertFalse(v.isValid("Abcd1234"))
        XCTAssertTrue(v.isValid("Abcd1234!"))
    }

    func testPostalCodeUSAndCA() {
        XCTAssertTrue(PostalCodeValidator(regionCode: "US").isValid("90210"))
        XCTAssertTrue(PostalCodeValidator(regionCode: "US").isValid("90210-1234"))
        XCTAssertFalse(PostalCodeValidator(regionCode: "US").isValid("ABCDE"))
        XCTAssertTrue(PostalCodeValidator(regionCode: "CA").isValid("K1A 0B1"))
        XCTAssertFalse(PostalCodeValidator(regionCode: "CA").isValid("12345"))
    }

    func testRuleComposition() {
        let nonEmpty = ValidationRule<String> { !$0.isEmpty }
        let short = ValidationRule<String> { $0.count <= 5 }
        let combined = nonEmpty && short
        XCTAssertTrue(combined.isValid("abc"))
        XCTAssertFalse(combined.isValid(""))
        XCTAssertFalse(combined.isValid("toolong"))
    }

    func testDelegatingValidators() {
        XCTAssertTrue(EmailValidator().isValid("a@b.com"))
        XCTAssertFalse(EmailValidator().isValid("nope"))
    }
}
