import XCTest
@testable import XCFrameworkMaker

final class GetArchsTests: XCTestCase {
  func testHappyPath() throws {
    var didRunShellCommand = [String]()
    let sut = GetArchs.live(runShellCommand: .init { command, _ in
      didRunShellCommand.append(command)
      return "i386 arm64 unknown"
    })
    let frameworkPath = Path("path/to/Some.framework")

    let archs = try sut(inFramework: frameworkPath)

    XCTAssertEqual(didRunShellCommand, ["lipo path/to/Some.framework/Some -archs"])
    XCTAssertEqual(archs, [.i386, .arm64])
  }
}
