/// Use lipo to extract provided architectures from binary file
public struct LipoExtract {
  var run: (Path, [Arch], Path, Log?) throws -> Void

  /// Extract provided architectures from binary file
  /// - Parameters:
  ///   - input: Path to the binary file
  ///   - archs: Architectures to be extracted
  ///   - output: Path to the extracted binary file
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  public func callAsFunction(input: Path, archs: [Arch], output: Path, _ log: Log? = nil) throws {
    try run(input, archs, output, log)
  }
}

public extension LipoExtract {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { input, archs, output, log in
      log?(.normal, "[LipoExtract]")
      log?(.verbose, "- input: \(input.string)")
      log?(.verbose, "- archs: \(archs.map(\.rawValue).joined(separator: ", "))")
      log?(.verbose, "- output: \(input.string)")
      let extract = archs.map { "-extract \($0)" }.joined(separator: " ")
      _ = try runShellCommand("lipo \(input.string) \(extract) -output \(output.string)", log?.indented())
    }
  }
}
