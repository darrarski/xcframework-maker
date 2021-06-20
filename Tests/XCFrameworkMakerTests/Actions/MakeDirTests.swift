import XCTest
@testable import XCFrameworkMaker

final class MakeDirTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = MakeDir.live(runShellCommand: .init { command in
      didRunShellCommand.append(command)
      return ""
    })
    let path = Path("new/directory/path")

    try sut(path)

    XCTAssertEqual(didRunShellCommand, ["mkdir -p new/directory/path"])
  }
}
