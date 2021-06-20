/// Creates directory
public struct CreateDir {
  var run: (Path) throws -> Void

  /// Create directory at provied path
  /// - Parameter path: Path of the directory to create
  /// - Throws: Error
  public func callAsFunction(_ path: Path) throws {
    try run(path)
  }
}

public extension CreateDir {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { path in
      _ = try runShellCommand("mkdir -p \(path.string)")
    }
  }
}
