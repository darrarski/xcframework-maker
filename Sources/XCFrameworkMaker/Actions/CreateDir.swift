/// Creates directory
public struct CreateDir {
  var run: (Path, Log?) throws -> Void

  /// Create directory at provied path
  /// - Parameters:
  ///   - path: Path of the directory to create
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  public func callAsFunction(_ path: Path, _ log: Log? = nil) throws {
    try run(path, log)
  }
}

public extension CreateDir {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { path, log in
      _ = try runShellCommand("mkdir -p \(path.string)", log?.indented())
    }
  }
}
