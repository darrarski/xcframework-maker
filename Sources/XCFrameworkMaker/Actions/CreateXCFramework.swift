/// Creates XCFramework from provided thin frameworks
public struct CreateXCFramework {
  var run: ([Path], Path) throws -> Void

  /// Create XCFramework from provided thin frameworks
  /// - Parameters:
  ///   - frameworks: Paths to thin frameworks
  ///   - path: Path to a directory where resulting XCFramework will be created
  /// - Throws: Error
  public func callAsFunction(from frameworks: [Path], at path: Path) throws {
    try run(frameworks, path)
  }
}

public extension CreateXCFramework {
  static func live(
    deletePath: DeletePath = .live(),
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { frameworks, path in
      let frameworkOptions = frameworks.map { "-framework \($0.string)" }.joined(separator: " ")
      let frameworkName = frameworks.first?.filenameExcludingExtension ?? ""
      let output = path.addingComponent("\(frameworkName).xcframework")
      try deletePath(output)
      _ = try runShellCommand("xcodebuild -create-xcframework \(frameworkOptions) -output \(output.string)")
    }
  }
}
