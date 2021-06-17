// swift-tools-version:5.4
import PackageDescription

let package = Package(
  name: "xcframework-maker",
  platforms: [
    .macOS(.v11),
  ],
  products: [
    .library(
      name: "XCFrameworkMaker",
      targets: [
        "XCFrameworkMaker",
      ]
    ),
    .executable(
      name: "make-xcframework",
      targets: [
        "make-xcframework",
      ]
    ),
  ],
  targets: [
    .target(
      name: "XCFrameworkMaker"
    ),
    .testTarget(
      name: "XCFrameworkMakerTests",
      dependencies: [
        .target(name: "XCFrameworkMaker"),
      ]
    ),
    .executableTarget(
      name: "make-xcframework",
      dependencies: [
        .target(name: "XCFrameworkMaker"),
      ]
    ),
  ]
)
