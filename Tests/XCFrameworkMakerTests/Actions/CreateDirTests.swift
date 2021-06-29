import XCTest
@testable import XCFrameworkMaker

final class CreateDirTests: XCTestCase {
  enum Action: Equatable {
    case didRunShellCommand(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var didPerformActions = [Action]()
    let sut = CreateDir.live(runShellCommand: .init { command, _ in
      didPerformActions.append(.didRunShellCommand(command))
      return ""
    })
    let path = Path("new/directory/path")
    let log = Log { level, message in
      didPerformActions.append(.didLog(level, message))
    }

    try sut(path, log)

    XCTAssertEqual(didPerformActions, [
      .didLog(.normal, "[CreateDir]"),
      .didLog(.verbose, "- path: \(path.string)"),
      .didRunShellCommand("mkdir -p new/directory/path")
    ])
  }
}
