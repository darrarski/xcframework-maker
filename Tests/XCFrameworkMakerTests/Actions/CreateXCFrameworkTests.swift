import XCTest
@testable import XCFrameworkMaker

final class CreateXCFrameworkTests: XCTestCase {
  enum Action: Equatable {
    case didRemovePath(Path)
    case didRunShellCommand(String)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = CreateXCFramework.live(
      removePath: .init { path in
        performedActions.append(.didRemovePath(path))
      },
      runShellCommand: .init { command in
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
      .didRemovePath(Path("output/path/Framework.xcframework")),
      .didRunShellCommand("xcodebuild -create-xcframework -framework device/Framework.framework -framework simulator/Framework.framework -output output/path/Framework.xcframework")
    ])
  }
}
