import XCTest
@testable import MatrixSwiftBaseCore

final class AppErrorTests: XCTestCase {

    func testInitDefaults() {
        let error = AppError(code: "X1", message: "Something broke")
        XCTAssertEqual(error.code, "X1")
        XCTAssertEqual(error.message, "Something broke")
        XCTAssertTrue(error.userInfo.isEmpty)
    }

    func testErrorDescriptionMatchesMessage() {
        let error = AppError(code: "X1", message: "User-facing text")
        XCTAssertEqual(error.errorDescription, "User-facing text")
        XCTAssertEqual((error as Error).localizedDescription, "User-facing text")
    }

    func testEquality() {
        let lhs = AppError(code: "X1", message: "M", userInfo: ["k": "v"])
        let rhs = AppError(code: "X1", message: "M", userInfo: ["k": "v"])
        let diff = AppError(code: "X2", message: "M", userInfo: ["k": "v"])
        XCTAssertEqual(lhs, rhs)
        XCTAssertNotEqual(lhs, diff)
    }

    func testResultTryCatchSuccess() {
        let result = Result<Int, Error>.tryCatch { 42 }
        XCTAssertEqual(try result.get(), 42)
    }

    func testResultTryCatchFailure() {
        let result = Result<Int, Error>.tryCatch { throw AppError(code: "X", message: "nope") }
        switch result {
        case .success: XCTFail("expected failure")
        case .failure(let error): XCTAssertEqual(error as? AppError, AppError(code: "X", message: "nope"))
        }
    }

    func testResultTryCatchAsyncSuccess() async {
        let result = await Result<String, Error>.tryCatch { "hello" }
        XCTAssertEqual(try? result.get(), "hello")
    }

    func testResultTryCatchAsyncFailure() async {
        let result = await Result<Int, Error>.tryCatch { () async throws -> Int in
            throw AppError(code: "Y", message: "async nope")
        }
        switch result {
        case .success: XCTFail("expected failure")
        case .failure(let error): XCTAssertEqual(error as? AppError, AppError(code: "Y", message: "async nope"))
        }
    }
}
