// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "PerfectRequestLogger",
    products: [
        .library(
            name: "PerfectRequestLogger",
            targets: ["PerfectRequestLogger"]),
    ],
    dependencies: [
			.package(url: "https://github.com/tuken/Perfect-Logger.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "PerfectRequestLogger",
            dependencies: ["PerfectLogger"]),
        .testTarget(
            name: "PerfectRequestLoggerTests",
            dependencies: ["PerfectRequestLogger"]),
    ]
)
