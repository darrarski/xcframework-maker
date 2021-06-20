/// Deletes file or directory
public struct DeletePath {
  var run: (Path) throws -> Void

  /// Delete file or directory
  /// - Parameter path: Path to file or directory to be removed
  /// - Throws: Error
  public func callAsFunction(_ path: Path) throws {
    try run(path)
  }
}

public extension DeletePath {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { path in
      _ = try runShellCommand("rm -Rf \(path.string)")
    }
  }
}