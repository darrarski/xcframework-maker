import XCTest
@testable import XCFrameworkMaker

final class LipoThinTests: XCTestCase {
  enum Action: Equatable {
    case didRunShellCommand(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = LipoThin.live(runShellCommand: .init { command, _ in
      performedActions.append(.didRunShellCommand(command))
      return ""
    })
    let input = Path("input/file")
    let arch = Arch.arm64
    let output = Path("output/file")
    let log = Log { level, message in
      performedActions.append(.didLog(level, message))
    }

    try sut(input: input, arch: arch, output: output, log)

    XCTAssertEqual(performedActions, [
      .didLog(.normal, "[LipoThin]"),
      .didLog(.verbose, "- input: \(input.string)"),
      .didLog(.verbose, "- arch: \(arch.rawValue)"),
      .didLog(.verbose, "- output: \(output.string)"),
      .didRunShellCommand("lipo input/file -thin arm64 -output output/file")
    ])
  }
}
