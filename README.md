# DangerSwiftPeriphery

[Danger Swift](https://github.com/danger/swift) plugin to run [Periphery](https://github.com/peripheryapp/periphery) on CI.


![Test](https://github.com/taji-taji/DangerSwiftPeriphery/actions/workflows/test.yml/badge.svg)
[![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)](https://github.com/tterb/atomic-design-ui/blob/master/LICENSEs)

## Features

This plugin will comment unreferenced code detected by periphery via Danger Swift.

![Image](Resources/Images/screenshot.png)


## Usage

### Preparation

- Install [Periphery](https://github.com/peripheryapp/periphery) on the machine you want to run Danger Swift on beforehand.
- [Danger Swift](https://github.com/danger/swift) Setup.

### Package.swift

```swift
let package = Package(
    // ...
    dependencies: [
        // Danger
        .package(name: "danger-swift", url: "https://github.com/danger/swift.git", from: "3.0.0"), // dev
        // Danger Plugins
        // Add the line below.
        .package(name: "DangerSwiftPeriphery", url: "https://github.com/taji-taji/DangerSwiftPeriphery.git", from: "1.0.0"), // dev
    ],
    targets: [
        // ...
        // Add DangerSwiftPeriphery to dependencies in DangerDependencies.
        .target(name: "DangerDependencies",
                dependencies: [
                    .product(name: "Danger", package: "danger-swift"),
                    "DangerSwiftPeriphery",
                ]),
        // ...
    ]
)
```


### Dangerfile.swift

If you have a `.periphery.yml` file, simply include the following in `Dangerfile.swift`

```swift
import Danger
import DangerSwiftPeriphery

DangerPeriphery.scan()
```

Alternatively, periphery options can be passed as arguments.

```swift
import Danger
import DangerSwiftPeriphery

DangerPeriphery.scan(arguments: [
    "--workspace MaApp.xcworkspace",
    "--schemes MyApp",
    "--index-store-path /path/to/index/store",
    "--skip-build"
])
```

You may also specify the location of periphery binaries.

```swift
import DangerSwiftPeriphery

DangerPeriphery.scan(peripheryPath: "/path/to/periphery")
```


