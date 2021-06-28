import XCTest
@testable import XCFrameworkMaker

final class CreateXCFrameworkTests: XCTestCase {
  enum Action: Equatable {
    case didDeletePath(Path)
    case didRunShellCommand(String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = CreateXCFramework.live(
      deletePath: .init { path, _ in
        performedActions.append(.didDeletePath(path))
      },
      runShellCommand: .init { command, _ in
        performedActions.append(.didRunShellCommand(command))
        return ""
      }
    )
    let frameworks = [
      Path("device/Framework.framework"),
      Path("simulator/Framework.framework")
    ]
    let path = Path("output/path")

    try sut(from: frameworks, at: path)

    XCTAssertEqual(performedActions, [
      .didDeletePath(Path("output/path/Framework.xcframework")),
      .didRunShellCommand("xcodebuild -create-xcframework -framework device/Framework.framework -framework simulator/Framework.framework -output output/path/Framework.xcframework")
    ])
  }
}
