// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PITPreviewSnapper",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "PITPreviewSnapper",
            targets: ["PITPreviewSnapper"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PITPreviewSnapper",
            dependencies: []),
        .testTarget(
            name: "PITPreviewSnapperTests",
            dependencies: ["PITPreviewSnapper"]),
    ]
)
