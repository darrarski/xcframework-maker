import XCTest
@testable import XCFrameworkMaker

final class RemovePathTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = RemovePath.live(runShellCommand: .init { command in
      didRunShellCommand.append(command)
      return ""
    })
    let path = Path("some/path")

    try sut(path)

    XCTAssertEqual(didRunShellCommand, ["rm -Rf some/path"])
  }
}
