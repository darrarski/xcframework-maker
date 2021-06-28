import XCTest
@testable import XCFrameworkMaker

final class LipoExtractTests: XCTestCase {
  enum Action: Equatable {
    case didRunShellCommand(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = LipoExtract.live(runShellCommand: .init { command, _ in
      performedActions.append(.didRunShellCommand(command))
      return ""
    })
    let input = Path("input/file")
    let archs = [Arch.i386, .arm64]
    let output = Path("output/file")
    let log = Log { level, message in
      performedActions.append(.didLog(level, message))
    }

    try sut(input: input, archs: archs, output: output, log)

    XCTAssertEqual(performedActions, [
      .didLog(.normal, "[LipoExtract]"),
      .didLog(.verbose, "- input: \(input.string)"),
      .didLog(.verbose, "- archs: \(archs.map(\.rawValue).joined(separator: ", "))"),
      .didLog(.verbose, "- output: \(input.string)"),
      .didRunShellCommand("lipo input/file -extract i386 -extract arm64 -output output/file")
    ])
  }
}
