// Generated automatically by Perfect Assistant Application
// Date: 2017-01-05 17:19:39 +0000
import PackageDescription
let package = Package(
    name: "PerfectRequestLogger",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/PerfectlySoft/Perfect-Logger.git", versions: Version(0,0,0)..<Version(0,9223372036854775807,9223372036854775807)),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 1),
        .Package(url: "https://github.com/iamjono/SwiftRandom.git", majorVersion: 0, minor: 2),
    ]
)