import XCTest
@testable import XCFrameworkMaker

final class MakeCopyTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = MakeCopy.live(runShellCommand: .init { command in
      didRunShellCommand.append(command)
      return ""
    })

    try sut(of: Path("source"), at: Path("destination"))

    XCTAssertEqual(didRunShellCommand, ["cp -fR source destination"])
  }
}
