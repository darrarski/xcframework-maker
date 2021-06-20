import Foundation

/// Creates new temporary directory
public struct CreateTempDir {
  var run: () throws -> Path

  /// Create new temporary directory and return its path
  /// - Throws: Error
  /// - Returns: Path to new temporary directory
  public func callAsFunction() throws -> Path {
    try run()
  }
}

public extension CreateTempDir {
  static func live(
    basePath: String = FileManager.default.temporaryDirectory.path,
    randomString: @escaping () -> String = { UUID().uuidString },
    createDir: CreateDir = .live()
  ) -> Self {
    .init {
      let path = Path(basePath).addingComponent("XCFrameworkMaker_\(randomString())")
      try createDir(path)
      return path
    }
  }
}
