import XCTest
@testable import XCFrameworkMaker

final class RunShellCommandTests: XCTestCase {
  enum Action: Equatable {
    case didShellOut(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let shellOutput = "shell output"
    let sut = RunShellCommand.live(shellOut: { command in
      performedActions.append(.didShellOut(command))
      return shellOutput
    })
    let shellCommand = "shell command"
    let log = Log { level, message in
      performedActions.append(.didLog(level, message))
    }

    let result = try sut(shellCommand, log)

    XCTAssertEqual(performedActions, [
      .didLog(.normal, "[RunShellCommand]"),
      .didLog(.verbose, "- command: \(shellCommand)"),
      .didShellOut(shellCommand),
      .didLog(.verbose, "- output: \(shellOutput)")
    ])
    XCTAssertEqual(result, shellOutput)
  }
}
