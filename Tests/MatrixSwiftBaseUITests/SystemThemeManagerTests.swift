import XCTest
import SwiftUI
import MatrixSwiftBaseCore
@testable import MatrixSwiftBaseUI

@MainActor
final class SystemThemeManagerTests: XCTestCase {

    // `SystemThemeManager` stores its choice in UserDefaults.standard under this key.
    private let key = "appSystemTheme"
    private var original: Any?

    override func setUp() {
        super.setUp()
        original = UserDefaults.standard.object(forKey: key)
        UserDefaults.standard.removeObject(forKey: key)
    }

    override func tearDown() {
        if let original {
            UserDefaults.standard.set(original, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        super.tearDown()
    }

    func testDefaultsToSystemTheme() {
        let manager = SystemThemeManager()
        XCTAssertTrue(manager.isSystemDefault())
        XCTAssertFalse(manager.isDarkMode())
        XCTAssertNil(manager.getColorScheme())
    }

    func testSetDarkTheme() {
        let manager = SystemThemeManager()
        manager.setTheme(theme: .dark)
        XCTAssertTrue(manager.isDarkMode())
        XCTAssertFalse(manager.isSystemDefault())
        XCTAssertEqual(manager.getColorScheme(), .dark)
    }

    func testSetLightTheme() {
        let manager = SystemThemeManager()
        manager.setTheme(theme: .light)
        XCTAssertFalse(manager.isDarkMode())
        XCTAssertFalse(manager.isSystemDefault())
        XCTAssertEqual(manager.getColorScheme(), .light)
    }

    func testSettingUnspecifiedReturnsToSystemDefault() {
        let manager = SystemThemeManager()
        manager.setTheme(theme: .dark)
        manager.setTheme(theme: .unspecified)
        XCTAssertTrue(manager.isSystemDefault())
        XCTAssertNil(manager.getColorScheme())
    }

    func testThemeIsPersistedAndSharedAcrossInstances() {
        SystemThemeManager().setTheme(theme: .dark)
        XCTAssertEqual(UserDefaults.standard.string(forKey: key), SystemThemes.dark.rawValue)
        XCTAssertTrue(SystemThemeManager().isDarkMode())
    }
}
