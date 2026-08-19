// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TFYSwiftTabbarKit",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(name: "TFYSwiftTabbarKit", targets: ["TFYSwiftTabbarKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "TFYSwiftKVCCatch",
            path: "TFYSwiftTabBarController/TFYSwiftTabbarKit",
            sources: ["TFYSwiftKVCCatch.m"],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include"),
            ]
        ),
        .target(
            name: "TFYSwiftTabbarKit",
            dependencies: [
                "TFYSwiftKVCCatch",
                .product(name: "Lottie", package: "lottie-ios"),
            ],
            path: "TFYSwiftTabBarController/TFYSwiftTabbarKit",
            exclude: [
                "include",
                "TFYSwiftKVCCatch.m",
            ],
            sources: [
                "Badge",
                "Core",
                "Extensions",
                "FlatDesign",
                "Lottie",
            ]
        ),
    ]
)
