// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Core",
            targets: ["Core"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift", branch: "master"),
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/ReactiveX/RxSwift", .upToNextMajor(from: "6.6.0")),
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "RxSwift", package: "RxSwift"),
            ]),
        .testTarget(
            name: "CoreTests",
            dependencies: ["Core"]),
    ]
)
