// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "macLanuch",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "macLanuch",
            targets: ["macLanuch"]
        )
    ],
    dependencies: [
        // 可以添加 KeyboardShortcuts 等库
    ],
    targets: [
        .executableTarget(
            name: "macLanuch",
            path: "macLanuch"
        )
    ]
)