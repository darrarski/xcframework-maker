/// Creates copy of file or directory
public struct MakeCopy {
  var run: (Path, Path) throws -> Void

  /// Create copy of file or directory
  /// - Parameters:
  ///   - source: Source file or directory path
  ///   - destination: Destination path
  /// - Throws: Error
  public func callAsFunction(of source: Path, at destination: Path) throws {
    try run(source, destination)
  }
}

public extension MakeCopy {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { source, destination in
      _ = try runShellCommand("cp -fR \(source.string) \(destination.string)")
    }
  }
}
