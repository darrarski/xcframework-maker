/// Creates XCFramework from provided thin frameworks
public struct CreateXCFramework {
  var run: ([Path], Path, Log?) throws -> Void

  /// Create XCFramework from provided thin frameworks
  /// - Parameters:
  ///   - frameworks: Paths to thin frameworks
  ///   - path: Path to a directory where resulting XCFramework will be created
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  public func callAsFunction(from frameworks: [Path], at path: Path, _ log: Log? = nil) throws {
    try run(frameworks, path, log)
  }
}

public extension CreateXCFramework {
  static func live(
    deletePath: DeletePath = .live(),
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { frameworks, path, log in
      log?(.normal, "[CreateXCFramework]")
      log?(.verbose, "- frameworks: \n\t\(frameworks.map(\.string).joined(separator: "\n\t"))")
      log?(.verbose, "- path: \(path.string)")
      let frameworkOptions = frameworks.map { "-framework \($0.string)" }.joined(separator: " ")
      let frameworkName = frameworks.first?.filenameExcludingExtension ?? ""
      let output = path.addingComponent("\(frameworkName).xcframework")
      try deletePath(output, log?.indented())
      _ = try runShellCommand(
        "xcodebuild -create-xcframework \(frameworkOptions) -output \(output.string)",
        log?.indented()
      )
    }
  }
}
