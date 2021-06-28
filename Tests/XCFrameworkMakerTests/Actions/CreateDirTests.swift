import XCTest
@testable import XCFrameworkMaker

final class CreateDirTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = CreateDir.live(runShellCommand: .init { command, _ in
      didRunShellCommand.append(command)
      return ""
    })
    let path = Path("new/directory/path")

    try sut(path)

    XCTAssertEqual(didRunShellCommand, ["mkdir -p new/directory/path"])
  }
}
