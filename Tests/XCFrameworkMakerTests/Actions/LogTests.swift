import XCTest
@testable import XCFrameworkMaker

final class LogTests: XCTestCase {
  func testNormalLogging() {
    var logged = [String]()
    let sut = Log.live(
      level: .normal,
      print: { logged.append($0) }
    )

    sut(.normal, "Normal level log")
    sut(.verbose, "Verbose level log")

    XCTAssertEqual(logged, ["Normal level log"])
  }

  func testVerboseLogging() {
    var logged = [String]()
    let sut = Log.live(
      level: .verbose,
      print: { logged.append($0) }
    )

    sut(.normal, "Normal level log")
    sut(.verbose, "Verbose level log")

    XCTAssertEqual(logged, [
      "Normal level log",
      "Verbose level log"
    ])
  }

  func testIndentedLogging() {
    var logged = [String]()
    let sut = Log.live(
      level: .normal,
      print: { logged.append($0) }
    ).indented()

    sut(.normal, "multiline\nlog\nmessage")

    XCTAssertEqual(logged, ["\tmultiline\n\tlog\n\tmessage"])
  }
}
