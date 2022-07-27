// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "DangerSwiftPeripheryDevTools",
    products: [
        .library(name: "DangerDeps[DangerSwiftPeripheryDevTools]",
                 type: .dynamic,
                 targets: ["DangerDependencies"]),
    ],
    dependencies: [
        .package(path: ".."),
        .package(url: "https://github.com/peripheryapp/periphery", branch: "master")
    ],
    targets: [
        .target(name: "DangerDependencies",
                dependencies: [
                    "DangerSwiftPeriphery"
                ])
    ]
)
