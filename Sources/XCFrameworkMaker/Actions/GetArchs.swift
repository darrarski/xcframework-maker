/// Gets architectures contained in a framework
public struct GetArchs {
  var run: (Path) throws -> [Arch]

  /// Get architectures contained in framework
  /// - Parameter frameworkPath: Path to framework
  /// - Throws: Error
  /// - Returns: Architectures contained in the framework
  public func callAsFunction(inFramework frameworkPath: Path) throws -> [Arch] {
    try run(frameworkPath)
  }
}

public extension GetArchs {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { frameworkPath in
      let frameworkName = frameworkPath.filenameExcludingExtension
      let binaryPath = frameworkPath.addingComponent(frameworkName)
      return try runShellCommand("lipo \(binaryPath.string) -archs")
        .components(separatedBy: " ")
        .compactMap(Arch.init(rawValue:))
    }
  }
}
