import XCTest
@testable import XCFrameworkMaker

final class CopyPathTests: XCTestCase {
  enum Action: Equatable {
    case didRunShellCommand(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = CopyPath.live(runShellCommand: .init { command, _ in
      performedActions.append(.didRunShellCommand(command))
      return ""
    })

    let source = Path("source")
    let destination = Path("destination")
    let log = Log { level, message in
      performedActions.append(.didLog(level, message))
    }

    try sut(of: source, at: destination, log)

    XCTAssertEqual(performedActions, [
      .didLog(.normal, "[CopyPath]"),
      .didLog(.verbose, "- source: \(source.string)"),
      .didLog(.verbose, "- destination: \(destination.string)"),
      .didRunShellCommand("cp -fR source destination")
    ])
  }
}
