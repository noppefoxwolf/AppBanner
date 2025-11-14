// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppBanner",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "AppBanner",
            targets: ["AppBanner"]
        ),
    ],
    targets: [
        .target(
            name: "AppBanner",
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ],
        ),
        .testTarget(
            name: "AppBannerTests",
            dependencies: ["AppBanner"]
        ),
    ]
)
