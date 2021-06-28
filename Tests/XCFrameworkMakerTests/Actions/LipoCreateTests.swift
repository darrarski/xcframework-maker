import XCTest
@testable import XCFrameworkMaker

final class LipoCreateTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = LipoCreate.live(runShellCommand: .init { command, _ in
      didRunShellCommand.append(command)
      return ""
    })
    let inputs = [Path("input/file1"), Path("input/file2")]
    let output = Path("output/file")

    try sut(inputs: inputs, output: output)

    XCTAssertEqual(didRunShellCommand, ["lipo input/file1 input/file2 -create -output output/file"])
  }
}
