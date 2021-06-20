/// Creates copy of a framework with provided architectures
public struct CopyFramework {
  var run: (Path, [Arch], Path) throws -> Path

  /// Create copy of a framework with provided architectures
  /// - Parameters:
  ///   - input: Path to the framework
  ///   - archs: Architectures to be included in the copied framework
  ///   - path: Path to a directory where framework copy will be created
  /// - Throws: Error
  /// - Returns: Path to the copied framework
  public func callAsFunction(_ input: Path, archs: [Arch], path: Path) throws -> Path {
    try run(input, archs, path)
  }
}

public extension CopyFramework {
  static func live(
    makeDir: MakeDir = .live(),
    copyPath: CopyPath = .live(),
    removePath: RemovePath = .live(),
    lipoExtract: LipoExtract = .live()
  ) -> Self {
    .init { input, archs, path in
      try makeDir(path)
      let output = path.addingComponent(input.lastComponent)
      try copyPath(of: input, at: output)
      let outputBinary = output.addingComponent(output.filenameExcludingExtension)
      try removePath(outputBinary)
      let inputBinary = input.addingComponent(input.filenameExcludingExtension)
      try lipoExtract.callAsFunction(input: inputBinary, archs: archs, output: outputBinary)
      return output
    }
  }
}
