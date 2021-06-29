public enum LogLevel: Equatable, CaseIterable {
  case normal
  case verbose
}

extension LogLevel: Comparable {
  public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
    allCases.firstIndex(of: lhs)! < allCases.firstIndex(of: rhs)!
  }
}
