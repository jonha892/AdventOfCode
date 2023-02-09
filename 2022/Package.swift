// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation


let package = Package(
    name: "Advent of Code",
    //platforms: [.linux],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(name: "advent", targets: ["advent"]),
        .library(name: "AOC", targets: ["AOC"]),
        .library(name: "AOCCore", targets: ["AOCCore"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "git@github.com:apple/swift-collections.git", from: "1.0.3"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .executableTarget(name: "advent", dependencies: ["AOC"]),
        
        .target(name: "AOC", dependencies: ["AOCCore", "AOC2022"]),
        
        .target(name: "AOC2022", dependencies: ["AOCCore"]),
        
        .target(name: "AOCCore", dependencies: [
            .product(name: "Algorithms", package: "swift-algorithms"),
            .product(name: "Collections", package: "swift-collections")
        ]),
        
        .testTarget(name: "AOCTests", dependencies: ["AOC"]),
        .testTarget(name: "AOCCoreTests", dependencies: ["AOCCore"])
    ]
)
