// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CatchPokemon",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CatchPokemon",
            targets: ["CatchPokemon"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/realm/realm-swift.git", branch: "master"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", branch: "master"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", branch: "main"),
        .package(path: "../Core")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CatchPokemon",
            dependencies: [
                .product(name: "RealmSwift", package: "realm-swift"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "Core", package: "Core"),
            ]),
        .testTarget(
            name: "CatchPokemonTests",
            dependencies: ["CatchPokemon"]),
    ]
)
