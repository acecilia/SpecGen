// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpecGen",
    dependencies: [
        .package(url: "https://github.com/apple/swift-package-manager.git", .revision("swift-DEVELOPMENT-SNAPSHOT-2019-03-04-a")),
        .package(url: "https://github.com/Carthage/Carthage.git", .revision("0.33.0")),
    ],
    targets: [
        .target(
            name: "specgen",
            dependencies: ["SPMUtility", "CarthageKit"]
        ),
        .testTarget(
            name: "SpecGenTests",
            dependencies: ["specgen"]
        ),
    ]
)
