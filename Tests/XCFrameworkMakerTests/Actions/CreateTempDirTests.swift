import XCTest
@testable import XCFrameworkMaker

final class CreateTempDirTests: XCTestCase {
  func testHappyPath() throws {
    var didMakeDir = [Path]()
    let basePath = "temp/dir/base/path"
    let randomString = "random"
    let sut = CreateTempDir.live(
      basePath: basePath,
      randomString: { randomString },
      makeDir: .init { didMakeDir.append($0) }
    )

    let path = try sut()

    let expectedPath = Path(basePath).addingComponent("XCFrameworkMaker_\(randomString)")
    XCTAssertEqual(didMakeDir, [expectedPath])
    XCTAssertEqual(path, expectedPath)
  }
}
