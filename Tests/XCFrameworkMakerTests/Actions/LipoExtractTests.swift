import XCTest
@testable import XCFrameworkMaker

final class LipoExtractTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = LipoExtract.live(runShellCommand: .init { command in
      didRunShellCommand.append(command)
      return ""
    })
    let input = Path("input/file")
    let archs = [Arch.i386, .arm64]
    let output = Path("output/file")

    try sut(input: input, archs: archs, output: output)

    XCTAssertEqual(didRunShellCommand, ["lipo input/file -extract i386 -extract arm64 -output output/file"])
  }
}
