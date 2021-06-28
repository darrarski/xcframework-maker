import XCTest
@testable import XCFrameworkMaker

final class CreateTempDirTests: XCTestCase {
  enum Action: Equatable {
    case didCreateDir(Path)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let basePath = "temp/dir/base/path"
    let randomString = "random"
    let sut = CreateTempDir.live(
      basePath: basePath,
      randomString: { randomString },
      createDir: .init { path, _ in
        performedActions.append(.didCreateDir(path))
      }
    )

    let log = Log { level, message in
      performedActions.append(.didLog(level, message))
    }

    let path = try sut(log)

    let expectedPath = Path(basePath).addingComponent("XCFrameworkMaker_\(randomString)")
    XCTAssertEqual(performedActions, [
      .didLog(.normal, "[CreateTempDir]"),
      .didCreateDir(expectedPath),
      .didLog(.verbose, "- path: \(path.string)")
    ])
    XCTAssertEqual(path, expectedPath)
  }
}
