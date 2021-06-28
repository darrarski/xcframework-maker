import ShellOut

/// Execute shell command
public struct RunShellCommand {
  var run: (String, Log?) throws -> String

  /// Execure shell command
  /// - Parameters:
  ///   - command: Command to execute
  ///   - log: Log action (defaults to nil for no logging)
  /// - Throws: Error
  /// - Returns: Shell command output
  public func callAsFunction(_ command: String, _ log: Log? = nil) throws -> String {
    try run(command, log)
  }
}

public extension RunShellCommand {
  static func live(
    shellOut: @escaping (String) throws -> String = { try shellOut(to: $0) }
  ) -> Self {
    .init { command, log in
      log?(.normal, "[RunShellCommand]")
      log?(.verbose, "- command: \(command)")
      let output = try shellOut(command)
      log?(.verbose, "- output: \(output)")
      return output
    }
  }
}
