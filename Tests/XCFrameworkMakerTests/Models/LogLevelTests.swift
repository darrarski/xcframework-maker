import XCTest
@testable import XCFrameworkMaker

final class LogLevelTests: XCTestCase {
  func testComparable() {
    XCTAssertTrue(LogLevel.normal < LogLevel.verbose)
    XCTAssertTrue(LogLevel.normal <= LogLevel.verbose)
    XCTAssertFalse(LogLevel.normal > LogLevel.verbose)
    XCTAssertFalse(LogLevel.normal >= LogLevel.verbose)
  }
}
