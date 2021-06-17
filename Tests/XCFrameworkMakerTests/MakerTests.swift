import XCTest
@testable import XCFrameworkMaker

final class MakerTest: XCTestCase {
  func testExample() {
    let sut = XCFrameworkMaker.Maker()

    XCTAssertEqual(sut.example(), "Hello, World!")
  }
}
