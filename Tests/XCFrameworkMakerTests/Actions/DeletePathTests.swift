import XCTest
@testable import XCFrameworkMaker

final class DeletePathTests: XCTestCase {
  enum Action: Equatable {
    case didRunShellCommand(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var didPerformActions = [Action]()
    let sut = DeletePath.live(runShellCommand: .init { command, _ in
      didPerformActions.append(.didRunShellCommand(command))
      return ""
    })
    let path = Path("some/path")
    let log = Log { level, message in
      didPerformActions.append(.didLog(level, message))
    }

    try sut(path, log)

    XCTAssertEqual(didPerformActions, [
      .didLog(.normal, "[DeletePath]"),
      .didLog(.verbose, "- path: \(path.string)"),
      .didRunShellCommand("rm -Rf some/path")
    ])
  }
}
