import XCTest
@testable import XCFrameworkMaker

final class RunShellCommandTests: XCTestCase {
  func testHappyPath() throws {
    var didShellOut = [String]()
    let shellOutput = "shell output"
    let sut = RunShellCommand.live(shellOut: { command in
      didShellOut.append(command)
      return shellOutput
    })
    let shellCommand = "shell command"

    let result = try sut(shellCommand)

    XCTAssertEqual(didShellOut, [shellCommand])
    XCTAssertEqual(result, shellOutput)
  }
}
