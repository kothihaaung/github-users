// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Di",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Di",
            targets: ["Di"]),
    ],
    dependencies: [
        .package(path: "../Domain"),
        .package(path: "../DataAccess"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Di", dependencies: [
                "Domain",
                .product(name: "DataAccess", package: "DataAccess")]),
    ]
)
