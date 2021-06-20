import XCTest
@testable import XCFrameworkMaker

final class DeletePathTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = DeletePath.live(runShellCommand: .init { command in
      didRunShellCommand.append(command)
      return ""
    })
    let path = Path("some/path")

    try sut(path)

    XCTAssertEqual(didRunShellCommand, ["rm -Rf some/path"])
  }
}
