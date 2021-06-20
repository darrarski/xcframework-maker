import ShellOut

/// Execute shell command
public struct RunShellCommand {
  var run: (String) throws -> String

  /// Execure shell command
  /// - Parameter command: Command to execute
  /// - Throws: Error
  /// - Returns: Shell command output
  public func callAsFunction(_ command: String) throws -> String {
    try run(command)
  }
}

public extension RunShellCommand {
  static func live(
    shellOut: @escaping (String) throws -> String = { try shellOut(to: $0) }
  ) -> Self {
    .init { command in
      try shellOut(command)
    }
  }
}
