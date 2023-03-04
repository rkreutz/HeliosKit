// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HeliosKit",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "HeliosKit",
            targets: ["HeliosKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
//        .binaryTarget(name: "helios", path: ".build/helios-rs/build/0.1.3.1/release/helios.xcframework"), // When building the xcframework locally
        .binaryTarget(
            name: "helios",
            url: "https://github.com/rkreutz/HeliosKit/releases/download/0.1.3.1/helios.xcframework.zip",
            checksum: "4487dc51c4bfd44c9430d4c5eefe27fe2c229cf9b7af03568c319504e21eb7e2"),
        .target(
            name: "HeliosKit",
            dependencies: ["helios"]),
        .testTarget(
            name: "HeliosKitTests",
            dependencies: ["HeliosKit"],
            exclude: ["Config.swift.example"])
    ]
)
