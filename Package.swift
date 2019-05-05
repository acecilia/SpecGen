// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CocoaPodsEndgame",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-package-manager.git", .revision("swift-DEVELOPMENT-SNAPSHOT-2019-03-04-a")),
        .package(url: "https://github.com/Carthage/Carthage.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CocoaPodsEndgame",
            dependencies: ["SPMUtility", "CarthageKit"]
        ),
        .testTarget(
            name: "CocoaPodsEndgameTests",
            dependencies: ["CocoaPodsEndgame"]
        ),
    ]
)
