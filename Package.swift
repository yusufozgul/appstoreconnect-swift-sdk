// swift-tools-version:5.7
import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/CreateAPI/URLQueryEncoder.git", from: "0.2.0"),
    .package(url: "https://github.com/apple/swift-crypto.git", from: "3.12.3")
]

var targetDependencies: [Target.Dependency] = [
    "AppStoreConnectApiCore",
    .product(name: "URLQueryEncoder", package: "URLQueryEncoder"),
    .product(name: "Crypto", package: "swift-crypto")
]

#if os(Linux)
dependencies.append(.package(url: "https://github.com/OpenCombine/OpenCombine.git", from: "0.14.0"))
targetDependencies.append(.product(name: "OpenCombine", package: "OpenCombine"))
#endif

let package = Package(
    name: "AppStoreConnect-Swift-SDK",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v9),
    ],
    products: [
        .library(name: "AppStoreConnect-Swift-SDK", targets: ["AppStoreConnect-Swift-SDK"]),
        .library(name: "AppStoreConnectApi", targets: ["AppStoreConnectApi"]),
        .library(name: "AppStoreConnectEnterpriseApi", targets: ["AppStoreConnectEnterpriseApi"]),
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "AppStoreConnect-Swift-SDK",
            dependencies: [
                "AppStoreConnectApiCore",
                "AppStoreConnectApi",
                "AppStoreConnectEnterpriseApi",
            ]
        ),
        .target(
            name: "AppStoreConnectApiCore",
            dependencies: [
                .product(name: "URLQueryEncoder", package: "URLQueryEncoder"),
                .product(name: "Crypto", package: "swift-crypto"),
            ]
        ),
        .target(
            name: "AppStoreConnectApi",
            dependencies: targetDependencies,
            exclude: ["OpenAPI/app_store_connect_api.json"]
        ),
        .target(
            name: "AppStoreConnectEnterpriseApi",
            dependencies: targetDependencies,
            exclude: ["OpenAPI/app_store_connect_api.json"]
        ),
        .testTarget(name: "AppStoreConnectApi-Tests", dependencies: ["AppStoreConnectApi"], path: "Tests"),
    ]
)
