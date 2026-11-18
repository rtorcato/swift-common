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

    func testCreditCardRejectsStrayCharactersAndLength() {
        let v = CreditCardValidator()
        XCTAssertTrue(v.isValid("4111-1111-1111-1111"))
        XCTAssertFalse(v.isValid("4111x1111y1111z1111")) // letters are not separators
        XCTAssertFalse(v.isValid("41111111111111111111111")) // longer than 19 digits
    }

    func testPostalCodeMoreRegions() {
        XCTAssertTrue(PostalCodeValidator(regionCode: "de").isValid("10115"))
        XCTAssertTrue(PostalCodeValidator(regionCode: "AU").isValid("2000"))
        XCTAssertTrue(PostalCodeValidator(regionCode: "NL").isValid("1012 AB"))
        XCTAssertTrue(PostalCodeValidator(regionCode: "JP").isValid("100-0001"))
        XCTAssertTrue(PostalCodeValidator(regionCode: "GB").isValid("SW1A 1AA"))
        XCTAssertFalse(PostalCodeValidator(regionCode: "AU").isValid("20000"))
    }

    func testProtocolCombinators() {
        let notExample = ValidationRule<String> { !$0.hasSuffix("@example.com") }
        let signup = EmailValidator().and(notExample)
        XCTAssertTrue(signup.isValid("me@torcato.dev"))
        XCTAssertFalse(signup.isValid("me@example.com"))

        let emailOrPhone = EmailValidator().or(PhoneValidator())
        XCTAssertTrue(emailOrPhone.isValid("a@b.com"))
        XCTAssertFalse(emailOrPhone.isValid("nope"))

        XCTAssertTrue(EmailValidator().negated().isValid("nope"))
        XCTAssertFalse((!EmailValidator().asRule()).isValid("a@b.com"))
    }

    func testExistentialValidator() {
        let validators: [any Validator<String>] = [EmailValidator(), URLValidator(), PasswordValidator()]
        XCTAssertEqual(validators.filter { $0.isValid("a@b.com") }.count, 1)
    }
}
