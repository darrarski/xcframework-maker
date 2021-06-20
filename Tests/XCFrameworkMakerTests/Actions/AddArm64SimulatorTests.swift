import XCTest
@testable import XCFrameworkMaker

final class AddArm64SimulatorTests: XCTestCase {
  enum Action: Equatable {
    case didLipoThin(Path, Arch, Path)
    case didLipoCreate([Path], Path)
    case didArm64ToSim(String)
    case didDeletePath(Path)
  }

  func testHappyPath() throws {
    var performedActions = [Action]()
    let sut = AddArm64Simulator.live(
      lipoThin: .init { input, arch, output in
        performedActions.append(.didLipoThin(input, arch, output))
      },
      lipoCrate: .init { input, output in
        performedActions.append(.didLipoCreate(input, output))
      },
      arm64ToSim: { path in
        performedActions.append(.didArm64ToSim(path))
      },
      deletePath: .init { path in
        performedActions.append(.didDeletePath(path))
      }
    )
    let deviceFramework = Path("device/Framework.framework")
    let simulatorFramework = Path("simulator/Framework.framework")

    try sut(deviceFramework: deviceFramework, simulatorFramework: simulatorFramework)

    XCTAssertEqual(performedActions, [
      .didLipoThin(Path("device/Framework.framework/Framework"), .arm64, Path("simulator/Framework.framework/Framework-arm64")),
      .didArm64ToSim("simulator/Framework.framework/Framework-arm64"),
      .didLipoCreate([Path("simulator/Framework.framework/Framework"), Path("simulator/Framework.framework/Framework-arm64")], Path("simulator/Framework.framework/Framework")),
      .didDeletePath(Path("simulator/Framework.framework/Framework-arm64"))
    ])
  }
}
