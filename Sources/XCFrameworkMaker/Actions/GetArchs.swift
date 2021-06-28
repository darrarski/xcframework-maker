/// Gets architectures contained in a framework
public struct GetArchs {
  var run: (Path, Log?) throws -> [Arch]

  /// Get architectures contained in framework
  /// - Parameters:
  ///   - frameworkPath: Path to framework
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  /// - Returns: Architectures contained in the framework
  public func callAsFunction(inFramework frameworkPath: Path, _ log: Log? = nil) throws -> [Arch] {
    try run(frameworkPath, log)
  }
}

public extension GetArchs {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { frameworkPath, log in
      let frameworkName = frameworkPath.filenameExcludingExtension
      let binaryPath = frameworkPath.addingComponent(frameworkName)
      let archs = try runShellCommand("lipo \(binaryPath.string) -archs", log?.indented())
        .components(separatedBy: " ")
        .compactMap(Arch.init(rawValue:))
      return archs
    }
  }
}
