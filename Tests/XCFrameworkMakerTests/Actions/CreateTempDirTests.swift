import XCTest
@testable import XCFrameworkMaker

final class CreateTempDirTests: XCTestCase {
  enum Action: Equatable {
    case didCreateDir(Path)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var didPerformActions = [Action]()
    let basePath = "temp/dir/base/path"
    let randomString = "random"
    let sut = CreateTempDir.live(
      basePath: basePath,
      randomString: { randomString },
      createDir: .init { path, _ in
        didPerformActions.append(.didCreateDir(path))
      }
    )
    let log = Log { level, message in
      didPerformActions.append(.didLog(level, message))
    }

    let path = try sut(log)

    let expectedPath = Path(basePath).addingComponent("XCFrameworkMaker_\(randomString)")
    XCTAssertEqual(didPerformActions, [
      .didLog(.normal, "[CreateTempDir]"),
      .didCreateDir(expectedPath),
      .didLog(.verbose, "- path: \(path.string)")
    ])
    XCTAssertEqual(path, expectedPath)
  }
}
