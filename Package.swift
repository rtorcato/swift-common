// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MatrixSwiftBase",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9)],
    // exclude: ["instructions.md"],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "MatrixSwiftBase", targets: ["MatrixSwiftBase"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
//        .package(url: "https://github.com/tbaranes/SwiftyUtils.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/jrendel/SwiftKeychainWrapper", branch: "develop"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.1.3"),
//        .package(url: "https://github.com/exyte/PopupView.git", branch: "master"),
        .package(url: "https://github.com/SDWebImage/SDWebImage", branch: "master"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSVGCoder", branch: "master"),
        .package(url: "https://github.com/exyte/SVGView", branch: "main")
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MatrixSwiftBase",
            dependencies: [],
            path: "Sources",
            exclude: [
                "Examples",
                "app-example.entitlements.plist",
                "Info-copy.plist"
            ],
            resources: []),
        .testTarget(
            name: "MatrixSwiftBaseTests",
            dependencies: ["MatrixSwiftBase"])
//            dependencies: ["MatrixSwiftBase", "SwiftyUtils"]),
    ]
)

// x-xcode-log://9054D712-B231-4370-9DFF-BA7072106FEE dependency 'Lottie' in target 'MatrixSwiftBase' requires explicit declaration; reference the package in the target dependency with '.product(name: "Lottie", package: "lottie-ios")'
