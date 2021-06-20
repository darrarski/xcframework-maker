/// Use lipo to create binary file from other binary files
public struct LipoCreate {
  var run: ([Path], Path) throws -> Void

  /// Create binary file from other binary files
  /// - Parameters:
  ///   - inputs: Paths to input files
  ///   - output: Path to output file
  /// - Throws: Error
  public func callAsFunction(inputs: [Path], output: Path) throws {
    try run(inputs, output)
  }
}

public extension LipoCreate {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { inputs, output in
      let input = inputs.map(\.string).joined(separator: " ")
      _ = try runShellCommand("lipo \(input) -create -output \(output.string)")
    }
  }
}
