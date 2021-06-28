import Arm64ToSim

/// Adds arm64 simulator support to a framework
public struct AddArm64Simulator {
  var run: (Path, Path, Log?) throws -> Void

  /// Add arm64 simulator support to a framework
  /// - Parameters:
  ///   - deviceFramework: Path to device framework file
  ///   - simulatorFramework: Path to simulator framework file
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  public func callAsFunction(deviceFramework: Path, simulatorFramework: Path, _ log: Log? = nil) throws {
    try run(deviceFramework, simulatorFramework, log)
  }
}

public extension AddArm64Simulator {
  static func live(
    lipoThin: LipoThin = .live(),
    lipoCrate: LipoCreate = .live(),
    arm64ToSim: @escaping (String) throws -> Void = arm64ToSim(_:),
    deletePath: DeletePath = .live()
  ) -> Self {
    .init { deviceFramework, simulatorFramework, log in
      let deviceBinary = deviceFramework.addingComponent(deviceFramework.filenameExcludingExtension)
      let simulatorBinary = simulatorFramework.addingComponent(simulatorFramework.filenameExcludingExtension)
      let arm64Binary = Path("\(simulatorBinary.string)-arm64")
      try lipoThin(input: deviceBinary, arch: .arm64, output: arm64Binary, log?.indented())
      try arm64ToSim(arm64Binary.string)
      try lipoCrate(inputs: [simulatorBinary, arm64Binary], output: simulatorBinary, log?.indented())
      try deletePath(arm64Binary, log?.indented())
    }
  }
}
