import XCTest
@testable import XCFrameworkMaker

final class CopyFrameworkTests: XCTestCase {
  enum Action: Equatable {
    case didCreateDir(Path)
    case didCopyPath(Path, Path)
    case didDeletePath(Path)
    case didLipoExtract(Path, [Arch], Path)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var didPerformActions = [Action]()
    let sut = CopyFramework.live(
      createDir: .init { path, _ in
        didPerformActions.append(.didCreateDir(path))
      },
      copyPath: .init { source, destination, _ in
        didPerformActions.append(.didCopyPath(source, destination))
      },
      deletePath: .init { path, _ in
        didPerformActions.append(.didDeletePath(path))
      },
      lipoExtract: .init { input, archs, output, _ in
        didPerformActions.append(.didLipoExtract(input, archs, output))
      }
    )
    let input = Path("input/Framework.framework")
    let archs = [Arch.i386, .arm64]
    let path = Path("output/path")
    let log = Log { level, message in
      didPerformActions.append(.didLog(level, message))
    }

    let output = try sut(input, archs: archs, path: path, log)

    XCTAssertEqual(didPerformActions, [
      .didLog(.normal, "[CopyFramework]"),
      .didLog(.verbose, "- input: \(input.string)"),
      .didLog(.verbose, "- archs: \(archs.map(\.rawValue).joined(separator: ", "))"),
      .didLog(.verbose, "- path: \(path.string)"),
      .didCreateDir(Path("output/path")),
      .didCopyPath(Path("input/Framework.framework"), Path("output/path/Framework.framework")),
      .didDeletePath(Path("output/path/Framework.framework/Framework")),
      .didLipoExtract(Path("input/Framework.framework/Framework"), [.i386, .arm64], Path("output/path/Framework.framework/Framework")),
      .didLog(.verbose, "- output: \(output.string)")
    ])
    XCTAssertEqual(output, path.addingComponent(input.lastComponent))
  }
}
