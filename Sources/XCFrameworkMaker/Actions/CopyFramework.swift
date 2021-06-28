/// Creates copy of a framework with provided architectures
public struct CopyFramework {
  var run: (Path, [Arch], Path, Log?) throws -> Path

  /// Create copy of a framework with provided architectures
  /// - Parameters:
  ///   - input: Path to the framework
  ///   - archs: Architectures to be included in the copied framework
  ///   - path: Path to a directory where framework copy will be created
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  /// - Returns: Path to the copied framework
  public func callAsFunction(_ input: Path, archs: [Arch], path: Path, _ log: Log? = nil) throws -> Path {
    try run(input, archs, path, log)
  }
}

public extension CopyFramework {
  static func live(
    createDir: CreateDir = .live(),
    copyPath: CopyPath = .live(),
    deletePath: DeletePath = .live(),
    lipoExtract: LipoExtract = .live()
  ) -> Self {
    .init { input, archs, path, log in
      try createDir(path, log?.indented())
      let output = path.addingComponent(input.lastComponent)
      try copyPath(of: input, at: output, log?.indented())
      let outputBinary = output.addingComponent(output.filenameExcludingExtension)
      try deletePath(outputBinary, log?.indented())
      let inputBinary = input.addingComponent(input.filenameExcludingExtension)
      try lipoExtract.callAsFunction(input: inputBinary, archs: archs, output: outputBinary, log?.indented())
      return output
    }
  }
}
