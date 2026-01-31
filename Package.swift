// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "IosAppIconGen",
    platforms: [
        .macOS(.v13)
    ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/twostraws/SwiftGD.git", from: "2.0.0"),
    ],
    
    targets: [
        .executableTarget(
            name: "IosAppIconGen",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftGD", package: "SwiftGD"),
            ]
        ),
    ]
)
