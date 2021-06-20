import Arm64ToSim

/// Adds arm64 simulator support to a framework
public struct AddArm64Simulator {
  var run: (Path, Path) throws -> Void

  /// Add arm64 simulator support to a framework
  /// - Parameters:
  ///   - deviceFramework: Path to device framework file
  ///   - simulatorFramework: Path to simulator framework file
  /// - Throws: Error
  public func callAsFunction(deviceFramework: Path, simulatorFramework: Path) throws {
    try run(deviceFramework, simulatorFramework)
  }
}

public extension AddArm64Simulator {
  static func live(
    lipoThin: LipoThin = .live(),
    lipoCrate: LipoCreate = .live(),
    arm64ToSim: @escaping (String) throws -> Void = arm64ToSim(_:),
    removePath: RemovePath = .live()
  ) -> Self {
    .init { deviceFramework, simulatorFramework in
      let deviceBinary = deviceFramework.addingComponent(deviceFramework.filenameExcludingExtension)
      let simulatorBinary = simulatorFramework.addingComponent(simulatorFramework.filenameExcludingExtension)
      let arm64Binary = Path("\(simulatorBinary.string)-arm64")
      try lipoThin(input: deviceBinary, arch: .arm64, output: arm64Binary)
      try arm64ToSim(arm64Binary.string)
      try lipoCrate(inputs: [simulatorBinary, arm64Binary], output: simulatorBinary)
      try removePath(arm64Binary)
    }
  }
}