// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "protoninboxrsvp",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "ProtonInboxRSVP",
            targets: ["ProtonInboxRSVP"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ProtonMail/protoncore_ios.git", exact: "32.7.1"),
        .package(path: "../ProtonInboxICal")
    ],
    targets: [
        .target(
            name: "ProtonInboxRSVP",
            dependencies: [
                .product(name: "ProtonCoreFeatures", package: "protoncore_ios"),
                .product(name: "ProtonCoreDataModel", package: "protoncore_ios"),
                .product(name: "ProtonInboxICal", package: "protoninboxical")
            ],
            path: "Sources"
        )
    ]
)
