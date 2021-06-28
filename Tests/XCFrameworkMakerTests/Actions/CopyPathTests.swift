import XCTest
@testable import XCFrameworkMaker

final class CopyPathTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = CopyPath.live(runShellCommand: .init { command, _ in
      didRunShellCommand.append(command)
      return ""
    })

    try sut(of: Path("source"), at: Path("destination"))

    XCTAssertEqual(didRunShellCommand, ["cp -fR source destination"])
  }
}
