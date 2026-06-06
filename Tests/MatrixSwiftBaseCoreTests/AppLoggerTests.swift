import XCTest
@testable import MatrixSwiftBaseCore

final class AppLoggerTests: XCTestCase {

    /// AppLogger writes to the unified logging system; output isn't easy to assert
    /// in-process. These tests verify the API surface compiles and the calls don't
    /// crash, which is what the wrapper actually guarantees.
    func testAllLevelsCompileAndDoNotThrow() {
        let logger = AppLogger(subsystem: "com.matrixswiftbase.tests", category: "logger-tests")
        logger.debug("debug")
        logger.info("info")
        logger.notice("notice")
        logger.warning("warning")
        logger.error("error")
        logger.critical("critical")
        XCTAssertTrue(true)
    }
}
