import XCTest
@testable import XCFrameworkMaker

final class LipoThinTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = LipoThin.live(runShellCommand: .init { command, _ in
      didRunShellCommand.append(command)
      return ""
    })
    let input = Path("input/file")
    let arch = Arch.arm64
    let output = Path("output/file")

    try sut(input: input, arch: arch, output: output)

    XCTAssertEqual(didRunShellCommand, ["lipo input/file -thin arm64 -output output/file"])
  }
}
