/// Creates copy of file or directory
public struct CopyPath {
  var run: (Path, Path, Log?) throws -> Void

  /// Create copy of file or directory
  /// - Parameters:
  ///   - source: Source file or directory path
  ///   - destination: Destination path
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  public func callAsFunction(of source: Path, at destination: Path, _ log: Log? = nil) throws {
    try run(source, destination, log)
  }
}

public extension CopyPath {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { source, destination, log in
      log?(.normal, "[CopyPath]")
      log?(.verbose, "- source: \(source.string)")
      log?(.verbose, "- destination: \(destination.string)")
      _ = try runShellCommand("cp -fR \(source.string) \(destination.string)", log?.indented())
    }
  }
}
