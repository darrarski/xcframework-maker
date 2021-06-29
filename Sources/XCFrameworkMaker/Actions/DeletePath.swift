/// Deletes file or directory
public struct DeletePath {
  var run: (Path, Log?) throws -> Void

  /// Delete file or directory
  /// - Parameters:
  ///   - path: Path to file or directory to be removed
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  public func callAsFunction(_ path: Path, _ log: Log? = nil) throws {
    try run(path, log)
  }
}

public extension DeletePath {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { path, log in
      log?(.normal, "[DeletePath]")
      log?(.verbose, "- path: \(path.string)")
      _ = try runShellCommand("rm -Rf \(path.string)", log?.indented())
    }
  }
}
