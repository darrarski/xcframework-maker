import XCTest
@testable import XCFrameworkMaker

final class GetArchsTests: XCTestCase {
  enum Action: Equatable {
    case didRunShellCommand(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = GetArchs.live(runShellCommand: .init { command, _ in
      performedActions.append(.didRunShellCommand(command))
      return "i386 arm64 unknown"
    })
    let frameworkPath = Path("path/to/Some.framework")
    let log = Log { level, message in
      performedActions.append(.didLog(level, message))
    }

    let archs = try sut(inFramework: frameworkPath, log)

    XCTAssertEqual(performedActions, [
      .didLog(.normal, "[GetArchs]"),
      .didLog(.verbose, "- frameworkPath: \(frameworkPath.string)"),
      .didRunShellCommand("lipo path/to/Some.framework/Some -archs"),
      .didLog(.verbose, "- archs: \(archs.map(\.rawValue).joined(separator: ", "))"),
    ])
    XCTAssertEqual(archs, [.i386, .arm64])
  }
}
