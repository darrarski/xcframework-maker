import Foundation

/// Creates new temporary directory
public struct CreateTempDir {
  var run: (Log?) throws -> Path

  /// Create new temporary directory and return its path
  /// - Parameter log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  /// - Returns: Path to new temporary directory
  public func callAsFunction(_ log: Log? = nil) throws -> Path {
    try run(log)
  }
}

public extension CreateTempDir {
  static func live(
    basePath: String = FileManager.default.temporaryDirectory.path,
    randomString: @escaping () -> String = { UUID().uuidString },
    createDir: CreateDir = .live()
  ) -> Self {
    .init { log in
      log?(.normal, "[CreateTempDir]")
      let path = Path(basePath).addingComponent("XCFrameworkMaker_\(randomString())")
      try createDir(path, log?.indented())
      log?(.verbose, "- path: \(path.string)")
      return path
    }
  }
}
