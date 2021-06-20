/// Removes file or directory
public struct RemovePath {
  var run: (Path) throws -> Void

  /// Remove file or directory
  /// - Parameter path: Path to file or directory to be removed
  /// - Throws: Error
  public func callAsFunction(_ path: Path) throws {
    try run(path)
  }
}

public extension RemovePath {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { path in
      _ = try runShellCommand("rm -Rf \(path.string)")
    }
  }
}
