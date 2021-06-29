/// Use lipo to create binary file from other binary files
public struct LipoCreate {
  var run: ([Path], Path, Log?) throws -> Void

  /// Create binary file from other binary files
  /// - Parameters:
  ///   - inputs: Paths to input files
  ///   - output: Path to output file
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  public func callAsFunction(inputs: [Path], output: Path, _ log: Log? = nil) throws {
    try run(inputs, output, log)
  }
}

public extension LipoCreate {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { inputs, output, log in
      log?(.normal, "[LipoCreate]")
      log?(.verbose, "- inputs: \n\t\(inputs.map(\.string).joined(separator: "\n\t"))")
      log?(.verbose, "- output: \(output.string)")
      let input = inputs.map(\.string).joined(separator: " ")
      _ = try runShellCommand("lipo \(input) -create -output \(output.string)", log?.indented())
    }
  }
}
