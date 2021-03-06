import XCTest
@testable import XCFrameworkMaker

final class CreateXCFrameworkTests: XCTestCase {
  enum Action: Equatable {
    case didDeletePath(Path)
    case didRunShellCommand(String)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var didPerformActions = [Action]()
    let sut = CreateXCFramework.live(
      deletePath: .init { path, _ in
        didPerformActions.append(.didDeletePath(path))
      },
      runShellCommand: .init { command, _ in
        didPerformActions.append(.didRunShellCommand(command))
        return ""
      }
    )
    let frameworks = [
      Path("device/Framework.framework"),
      Path("simulator/Framework.framework")
    ]
    let path = Path("output/path")
    let log = Log { level, message in
      didPerformActions.append(.didLog(level, message))
    }

    try sut(from: frameworks, at: path, log)

    XCTAssertEqual(didPerformActions, [
      .didLog(.normal, "[CreateXCFramework]"),
      .didLog(.verbose, "- frameworks: \n\t\(frameworks.map(\.string).joined(separator: "\n\t"))"),
      .didLog(.verbose, "- path: \(path.string)"),
      .didDeletePath(Path("output/path/Framework.xcframework")),
      .didRunShellCommand("xcodebuild -create-xcframework -framework device/Framework.framework -framework simulator/Framework.framework -output output/path/Framework.xcframework")
    ])
  }
}
