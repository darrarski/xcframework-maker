/// Use lipo to create thin binary file with provided architecture
public struct LipoThin {
  var run: (Path, Arch, Path) throws -> Void

  /// Create thin binary file with provided architecture
  /// - Parameters:
  ///   - input: Path to the input file
  ///   - arch: Architecture to be included in the output
  ///   - output: Path to the output file
  /// - Throws: Error
  public func callAsFunction(input: Path, arch: Arch, output: Path) throws {
    try run(input, arch, output)
  }
}

public extension LipoThin {
  static func live(
    runShellCommand: RunShellCommand = .live()
  ) -> Self {
    .init { input, arch, output in
      _ = try runShellCommand("lipo \(input.string) -thin \(arch.rawValue) -output \(output.string)")
    }
  }
}
