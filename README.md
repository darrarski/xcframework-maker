# xcframework-maker

![swift 5.4](https://img.shields.io/badge/swift-5.4-orange.svg)
![platform macOS](https://img.shields.io/badge/platform-macOS-blue)
![SPM supported](https://img.shields.io/badge/SPM-supported-green)

macOS utility for creating SPM-compatible XCFramework from a legacy fat-framework.

## 📝 Description

`make-xcframework` is a simple command-line utility written in Swift that creates **XCFramework** file from fat framework files. The resulting XCFramework file can be added as a dependency to your **Swift Package**, using `.binaryTarget` (read more in [official documentation](https://docs.swift.org/package-manager/PackageDescription/PackageDescription.html)).

Optionally, **arm64-simulator** support can be included in the resulting XCFramework to allow development on a computer with **Apple Silicon (M1)** processor without a need to run Xcode through Rosetta.

The `xcframework-maker` Swift Package contains `make-xcframework` that can be used from the command line and `XCFrameworkMaker` library that you can integrate with your Swift Package and use programmatically.

**Note:** [arm64-to-sim](http://github.com/darrarski/arm64-to-sim) is used to "hack" the native (device) **arm64** architecture slice so it can be used in a simulator running on Apple Silicon. This is an experimental feature, and **it can fail for many reasons**. It was tested and proved to be working with the `GoogleInteractiveMediaAds` dynamic fat framework, but your experience may vary.

## 🛠 Build

Use Swift 5.4 for building the utility on macOS:

```sh
swift build -c release
```

You can copy the executable or run it directly from the build directory:

```sh
.build/release/make-xcframework
```

## ▶️ Usage

```
OVERVIEW: Utility for creating XCFramework from legacy fat-framework files.

Use this tool to create XCFramework from legacy fat-framework files. Resulting XCFramework can be
added as a dependency to your Swift Package. Optionally arm64-simulator support can be included in
the resulting XCFramework, so it can be used on M1 Mac without the need to run Xcode through
Rosetta.

USAGE: make-xcframework [-ios <path>] [-tvos <path>] [-arm64sim] -output <path>

OPTIONS:
  -ios <path>             iOS input framework path.
        Provide a path to the iOS fat framework that should be included in the resulting
        XCFramework. Eg "path/to/iOS/Framework.framework"
  -tvos <path>            tvOS input framework path.
        Provide a path to the tvOS fat framework that should be included in the resulting
        XCFramework. Eg "path/to/tvOS/Framework.framework"
  -arm64sim               Add support for arm64 simulator.
        Use device-arm64 architecture slice as a simulator-arm64 architecture slice and include it
        the resulting XCFramework. This makes development possible on M1 Mac without using Rosetta.
  -output <path>          Output directory path.
        Privide path to a directiory where resulting XCFramework should be created. Eg
        "path/to/output/directory"
  -help, -h               Show help information.
```

### Example - GoogleInteractiveMediaAds

1. Download GoogleInteractiveMediaAds fat-frameworks from Google website:
  - [IMA SDK for iOS](https://developers.google.com/interactive-media-ads/docs/sdks/ios/dai/download)
  - [IMA SDK for tvOS](https://developers.google.com/interactive-media-ads/docs/sdks/tvos/dai/download)
2. Unzip downloaded files.
3. Run `make-xcframework`:

  ```sh
  make-xcframework \
      -ios path/to/ios/GoogleInteractiveMediaAds.framework \
      -tvos path/to/tvos/GoogleInteractiveMediaAds.framework \
      -arm64sim \
      -output output/path
  ```

4. Resulting XCFramework will be created in provided output directory:

  ```sh
  output/path/GoogleInteractiveMediaAds.xcframework
  ```

## ☕️ Do you like the project?

<a href="https://www.buymeacoffee.com/darrarski" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" height="60" width="217" style="height: 60px !important;width: 217px !important;" ></a>

## 📄 License

Copyright © 2021 Dariusz Rybicki Darrarski

License: [MIT](LICENSE)
