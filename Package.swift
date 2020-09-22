// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mockturtle-ios",
    products: [
        .library(
            name: "mockturtle-ios",
            targets: ["Mockturtle"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "4.8.1")
    ],
    targets: [
        .target(
            name: "Mockturtle",
            dependencies: ["Alamofire"]
        )
    ]
)
