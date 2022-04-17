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
        .package(url: "https://github.com/peripheryapp/periphery", branch: "master")
    ],
    targets: [
        .target(name: "DangerSwiftPeripheryDevTools",
                dependencies: [
                    "DangerSwiftPeriphery"
                ])
    ]
)
