/// Use lipo to extract provided architectures from binary file
public struct LipoExtract {
  var run: (Path, [Arch], Path) throws -> Void

  /// Extract provided architectures from binary file
  /// - Parameters:
  ///   - input: Path to the binary file
  ///   - archs: Architectures to be extracted
  ///   - output: Path to the extracted binary file
  /// - Throws: Error
  public func callAsFunction(input: Path, archs: [Arch], output: Path) throws {
    try run(input, archs, output)
  }
}

public extension LipoExtract {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { input, archs, output in
      let extract = archs.map { "-extract \($0)" }.joined(separator: " ")
      _ = try runShellCommand("lipo \(input.string) \(extract) -output \(output.string)")
    }
  }
}
