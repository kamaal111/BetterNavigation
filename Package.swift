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
        .package(url: "https://github.com/Kamaalio/SalmonUI.git", "5.1.0" ..< "6.0.0"),
        .package(path: "../SwiftStructures")
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
