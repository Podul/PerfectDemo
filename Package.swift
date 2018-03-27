// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// 软件包管理
import PackageDescription

let urls = [
    "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",      // HTTP服务
    "https://github.com/PerfectlySoft/Perfect-MySQL.git",           // MySQL服务
    "https://github.com/PerfectlySoft/Perfect-Mustache.git"         // Mustache
]


//let package = Package(
//    name: "Perfect",
//    targets: [],
//    dependencies: urls.map { .Package(url: $0, versions: Version(3,0,0)..<Version(4,0,0)) }
//)


let package = Package(
    name: "Perfect",
    dependencies: [
        // HTTP服务
        .package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", from: "3.0.0"),
        // MySQL服务
        .package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", from: "3.0.0"),
        //         .Package(url: "https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2)
        // Mustache
        .package(url: "https://github.com/PerfectlySoft/Perfect-Mustache.git", from: "3.0.0"),
        ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Perfect",
            dependencies: ["PerfectHTTPServer", "PerfectMySQL", "PerfectMustache"]),
        ]
)
