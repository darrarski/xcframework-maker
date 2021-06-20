import Foundation

/// Creates XCFramework from provided fat frameworks
public struct MakeXCFramework {
  var run: (Path?, Path?, Bool, Path) throws -> Void

  /// Create XCFramework from provided fat frameworks
  /// - Parameters:
  ///   - iOSPath: Path to iOS fat framework
  ///   - tvOSPath: Path to tvOS fat framework
  ///   - arm64sim: If true, add arm64-simulator support
  ///   - path: Path to a directory where resulting XCFramework will be created
  /// - Throws: Error
  public func callAsFunction(
    iOS iOSPath: Path?,
    tvOS tvOSPath: Path?,
    arm64sim: Bool,
    at path: Path
  ) throws {
    try run(iOSPath, tvOSPath, arm64sim, path)
  }
}

extension MakeXCFramework {
  public struct EmptyInputError: LocalizedError, Equatable {
    public init() {}

    public var errorDescription: String? {
      "Empty inputs. Provide at least one input fat framework."
    }
  }
}

public extension MakeXCFramework {
  static func live(
    createTempDir: CreateTempDir = .live(),
    getArchs: GetArchs = .live(),
    copyFramework: CopyFramework = .live(),
    addArm64Simulator: AddArm64Simulator = .live(),
    createXCFramework: CreateXCFramework = .live()
  ) -> Self {
    .init { iOSPath, tvOSPath, arm64sim, output in
      guard iOSPath != nil || tvOSPath != nil else {
        throw EmptyInputError()
      }

      let tempDir = try createTempDir()
      var thinFrameworks = [Path]()

      if let path = iOSPath {
        let archs = try getArchs(inFramework: path)
        let deviceArchs = [Arch.armv7, .arm64].filter(archs.contains(_:))
        let simulatorArchs = [Arch.i386, .x86_64].filter(archs.contains(_:))
        let deviceOutput = tempDir.addingComponent("ios-device")
        let simulatorOutput = tempDir.addingComponent("ios-simulator")
        let deviceFramework = try copyFramework(path, archs: deviceArchs, path: deviceOutput)
        let simulatorFramework = try copyFramework(path, archs: simulatorArchs, path: simulatorOutput)
        if arm64sim {
          try addArm64Simulator(deviceFramework: deviceFramework, simulatorFramework: simulatorFramework)
        }
        thinFrameworks.append(contentsOf: [deviceFramework, simulatorFramework])
      }

      if let path = tvOSPath {
        let archs = try getArchs(inFramework: path)
        let deviceArchs = [Arch.armv7, .arm64].filter(archs.contains(_:))
        let simulatorArchs = [Arch.i386, .x86_64].filter(archs.contains(_:))
        let deviceOutput = tempDir.addingComponent("tvos-device")
        let simulatorOutput = tempDir.addingComponent("tvos-simulator")
        let deviceFramework = try copyFramework(path, archs: deviceArchs, path: deviceOutput)
        let simulatorFramework = try copyFramework(path, archs: simulatorArchs, path: simulatorOutput)
        if arm64sim {
          try addArm64Simulator(deviceFramework: deviceFramework, simulatorFramework: simulatorFramework)
        }
        thinFrameworks.append(contentsOf: [deviceFramework, simulatorFramework])
      }

      try createXCFramework(from: thinFrameworks, at: output)
    }
  }
}
