//
//  SystemInfoHelper.swift
//  MatrixSwiftBase
//
//  Pure-Foundation system/app metadata. UI-coupled screen info lives in the
//  UI target (ScreenHelper / SizeClassHelper).
//

import Foundation
#if canImport(Darwin)
import Darwin
#endif

public final class SystemInfoHelper: Sendable {

    public init() { }

    /// OS name, e.g. `"iOS"`, `"macOS"`, `"tvOS"`, `"watchOS"`.
    public static var osName: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(watchOS)
        return "watchOS"
        #else
        return "unknown"
        #endif
    }

    /// OS version, e.g. `"17.2.1"`.
    public static var osVersion: String {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return "\(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
    }

    /// Hardware model identifier, e.g. `"iPhone16,2"` or `"MacBookPro18,3"`.
    /// On a simulator this is the simulated device's identifier. Returns nil when unavailable.
    public static var deviceModel: String? {
        #if os(macOS)
        return sysctlString("hw.model")
        #elseif canImport(Darwin)
        #if targetEnvironment(simulator)
        if let simulated = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"], !simulated.isEmpty {
            return simulated
        }
        #endif
        var systemInfo = utsname()
        uname(&systemInfo)
        let identifier = withUnsafeBytes(of: &systemInfo.machine) { raw -> String in
            let bytes = raw.prefix { $0 != 0 }
            return String(decoding: bytes, as: UTF8.self)
        }
        return identifier.isEmpty ? nil : identifier
        #else
        return nil
        #endif
    }

    /// Current locale identifier, e.g. `"en_US"`.
    public static var localeIdentifier: String {
        Locale.current.identifier
    }

    /// App bundle identifier (nil in some test/CLI contexts).
    public static var bundleIdentifier: String? {
        Bundle.main.bundleIdentifier
    }

    /// Marketing version (`CFBundleShortVersionString`).
    public static var appVersion: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    /// Build number (`CFBundleVersion`).
    public static var buildNumber: String? {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

    #if os(macOS)
    private static func sysctlString(_ name: String) -> String? {
        var size = 0
        guard sysctlbyname(name, nil, &size, nil, 0) == 0, size > 0 else { return nil }
        var buffer = [CChar](repeating: 0, count: size)
        guard sysctlbyname(name, &buffer, &size, nil, 0) == 0 else { return nil }
        let value = String(cString: buffer)
        return value.isEmpty ? nil : value
    }
    #endif
}
