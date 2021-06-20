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
  dependencies: [
    .package(
      name: "swift-argument-parser",
      url: "https://github.com/apple/swift-argument-parser.git",
      .upToNextMajor(from: "0.4.3")
    ),
    .package(
      name: "ShellOut",
      url: "https://github.com/JohnSundell/ShellOut.git",
      .upToNextMajor(from: "2.3.0")
    ),
    .package(
      name: "arm64-to-sim",
      url: "https://github.com/darrarski/arm64-to-sim.git",
      .upToNextMajor(from: "1.0.0")
    ),
  ],
  targets: [
    .target(
      name: "XCFrameworkMaker",
      dependencies: [
        .product(
          name: "ShellOut",
          package: "ShellOut"
        ),
        .product(
          name: "Arm64ToSim",
          package: "arm64-to-sim"
        ),
      ]
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
        .product(
          name: "ArgumentParser",
          package: "swift-argument-parser"
        ),
      ]
    ),
  ]
)
