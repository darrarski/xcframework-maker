import XCTest
@testable import XCFrameworkMaker

final class CopyFrameworkTests: XCTestCase {
  enum Action: Equatable {
    case didCreateDir(Path)
    case didCopyPath(Path, Path)
    case didDeletePath(Path)
    case didLipoExtract(Path, [Arch], Path)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = CopyFramework.live(
      createDir: .init { path in
        performedActions.append(.didCreateDir(path))
      },
      copyPath: .init { source, destination in
        performedActions.append(.didCopyPath(source, destination))
      },
      deletePath: .init { path in
        performedActions.append(.didDeletePath(path))
      },
      lipoExtract: .init { input, archs, output in
        performedActions.append(.didLipoExtract(input, archs, output))
      }
    )
    let input = Path("input/Framework.framework")
    let archs = [Arch.i386, .arm64]
    let path = Path("output/path")

    let output = try sut(input, archs: archs, path: path)

    XCTAssertEqual(performedActions, [
      .didCreateDir(Path("output/path")),
      .didCopyPath(Path("input/Framework.framework"), Path("output/path/Framework.framework")),
      .didDeletePath(Path("output/path/Framework.framework/Framework")),
      .didLipoExtract(Path("input/Framework.framework/Framework"), [.i386, .arm64], Path("output/path/Framework.framework/Framework"))
    ])
    XCTAssertEqual(output, path.addingComponent(input.lastComponent))
  }
}
