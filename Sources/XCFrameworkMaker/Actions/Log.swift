/// Logs messages
public struct Log {
  var run: (LogLevel, String) -> Void

  /// Log message
  /// - Parameters:
  ///   - level: Log level
  ///   - message: Message to be logged
  public func callAsFunction(_ level: LogLevel, _ message: String) {
    run(level, message)
  }
}

public extension Log {
  static func live(
    level logginLevel: LogLevel = .normal,
    print: @escaping (String) -> Void = { print($0) }
  ) -> Self {
    .init { level, message in
      guard level <= logginLevel else { return }
      print(message)
    }
  }
}

public extension Log {
  /// Returns modified Log that indents messages with a tab character
  /// - Returns: Log
  func indented() -> Self {
    .init { level, message in
      let indentation = "\t"
      let indentedMessage = message
        .split(separator: "\n")
        .map { indentation + $0 }
        .joined(separator: "\n")
      self.callAsFunction(level, indentedMessage)
    }
  }
}
