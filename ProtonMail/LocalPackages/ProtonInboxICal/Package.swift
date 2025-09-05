// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "protoninboxical",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "ProtonInboxICal",
            targets: ["ProtonInboxICal"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ProtonInboxICal",
            dependencies: ["ICalKitWrapper"],
            path: "Sources/ProtonInboxICal"
        ),
        .target(
            name: "ICalKitWrapper",
            path: "Sources/ICalKitWrapper"
        )
    ]
)
