// swift-tools-version: 5.9

import PackageDescription

// Swift 6 strict concurrency checking (#14). An experimental feature rather
// than unsafeFlags, so the package stays usable as a dependency.
let strictConcurrency: [SwiftSetting] = [.enableExperimentalFeature("StrictConcurrency")]

let package = Package(
    name: "MatrixSwiftBase",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9)],
    products: [
        .library(name: "MatrixSwiftBaseCore", targets: ["MatrixSwiftBaseCore"]),
        .library(name: "MatrixSwiftBaseUI", targets: ["MatrixSwiftBaseUI"])
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.1.3")
    ],
    targets: [
        .target(
            name: "MatrixSwiftBaseCore",
            path: "Sources/MatrixSwiftBaseCore",
            swiftSettings: strictConcurrency
        ),
        .target(
            name: "MatrixSwiftBaseUI",
            dependencies: ["MatrixSwiftBaseCore"],
            path: "Sources/MatrixSwiftBaseUI",
            swiftSettings: strictConcurrency
        ),
        .testTarget(
            name: "MatrixSwiftBaseCoreTests",
            dependencies: ["MatrixSwiftBaseCore"]
        ),
        .testTarget(
            name: "MatrixSwiftBaseUITests",
            dependencies: ["MatrixSwiftBaseUI"]
        )
    ]
)
