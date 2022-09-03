// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "DevTools",
    platforms: [.macOS(.v10_11)],
    dependencies: [
        .package(url: "https://github.com/tuist/xcbeautify", from: "0.13.0"),
    ],
    targets: [
        .target(name: "DevTools", path: "")
    ]
)
