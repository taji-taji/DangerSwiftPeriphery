// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DangerSwiftPeripheryDevTools",
    products: [
        .library(name: "DangerSwiftPeripheryDevTools",
                 type: .dynamic,
                 targets: ["DangerSwiftPeripheryDevTools"]),
    ],
    dependencies: [
        .package(path: ".."),
        .package(url: "https://github.com/peripheryapp/periphery", from: "2.0.0")
    ],
    targets: [
        .target(name: "DangerSwiftPeripheryDevTools",
                dependencies: [
                    "DangerSwiftPeriphery"
                ])
    ]
)
