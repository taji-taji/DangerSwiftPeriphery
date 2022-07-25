// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DangerSwiftPeriphery",
    products: [
        .library(
            name: "DangerSwiftPeriphery",
            targets: ["DangerSwiftPeriphery"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "DangerSwiftPeriphery",
            dependencies: [
                .product(name: "Danger", package: "swift")
            ]),
        .testTarget(
            name: "DangerSwiftPeripheryTests",
            dependencies: ["DangerSwiftPeriphery"]),
    ]
)
