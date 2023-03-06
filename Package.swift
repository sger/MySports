// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sports",
    platforms: [
      .iOS(.v14)
    ],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "AppFeature", targets: ["AppFeature"])
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Models"),
        .target(name: "Networking", dependencies: ["Models"]),
        .target(name: "AppFeature")
    ]
)
