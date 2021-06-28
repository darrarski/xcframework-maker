import XCTest
@testable import XCFrameworkMaker

final class CreateTempDirTests: XCTestCase {
  func testHappyPath() throws {
    var didCreateDir = [Path]()
    let basePath = "temp/dir/base/path"
    let randomString = "random"
    let sut = CreateTempDir.live(
      basePath: basePath,
      randomString: { randomString },
      createDir: .init { path, _ in didCreateDir.append(path) }
    )

    let path = try sut()

    let expectedPath = Path(basePath).addingComponent("XCFrameworkMaker_\(randomString)")
    XCTAssertEqual(didCreateDir, [expectedPath])
    XCTAssertEqual(path, expectedPath)
  }
}
