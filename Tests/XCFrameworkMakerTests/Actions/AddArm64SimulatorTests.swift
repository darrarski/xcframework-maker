import XCTest
@testable import XCFrameworkMaker

final class AddArm64SimulatorTests: XCTestCase {
  enum Action: Equatable {
    case didLipoThin(Path, Arch, Path)
    case didLipoCreate([Path], Path)
    case didArm64ToSim(String)
    case didDeletePath(Path)
    case didLog(LogLevel, String)
  }

  func testHappyPath() throws {
    var didPerformActions = [Action]()
    let sut = AddArm64Simulator.live(
      lipoThin: .init { input, arch, output, _ in
        didPerformActions.append(.didLipoThin(input, arch, output))
      },
      lipoCrate: .init { input, output, _ in
        didPerformActions.append(.didLipoCreate(input, output))
      },
      arm64ToSim: { path in
        didPerformActions.append(.didArm64ToSim(path))
      },
      deletePath: .init { path, _ in
        didPerformActions.append(.didDeletePath(path))
      }
    )
    let deviceFramework = Path("device/Framework.framework")
    let simulatorFramework = Path("simulator/Framework.framework")
    let log = Log { level, message in
      didPerformActions.append(.didLog(level, message))
    }

    try sut(deviceFramework: deviceFramework, simulatorFramework: simulatorFramework, log)

    XCTAssertEqual(didPerformActions, [
      .didLog(.normal, "[AddArm64Simulator]"),
      .didLog(.verbose, "- deviceFramework: \(deviceFramework.string)"),
      .didLog(.verbose, "- simulatorFramework: \(simulatorFramework.string)"),
      .didLipoThin(Path("device/Framework.framework/Framework"), .arm64, Path("simulator/Framework.framework/Framework-arm64")),
      .didArm64ToSim("simulator/Framework.framework/Framework-arm64"),
      .didLipoCreate([Path("simulator/Framework.framework/Framework"), Path("simulator/Framework.framework/Framework-arm64")], Path("simulator/Framework.framework/Framework")),
      .didDeletePath(Path("simulator/Framework.framework/Framework-arm64"))
    ])
  }
}
