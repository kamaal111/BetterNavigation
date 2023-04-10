// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BetterNavigation",
    platforms: [
        .macOS(.v11),
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "BetterNavigation",
            targets: ["BetterNavigation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Kamaalio/SalmonUI.git", "6.0.0" ..< "7.0.0"),
        .package(url: "https://github.com/kamaal111/SwiftStructures.git", "1.0.0" ..< "2.0.0"),
    ],
    targets: [
        .target(
            name: "BetterNavigation",
            dependencies: [
                "SalmonUI",
                "SwiftStructures",
            ]),
        .testTarget(
            name: "BetterNavigationTests",
            dependencies: ["BetterNavigation"]),
    ]
)
