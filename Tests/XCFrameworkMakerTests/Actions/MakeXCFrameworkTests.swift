import XCTest
@testable import XCFrameworkMaker

final class MakeXCFrameworkTests: XCTestCase {
  enum Action: Equatable {
    case didCreateTempDir
    case didGetArchs(Path)
    case didCopyFramework(Path, [Arch], Path)
    case didAddArm64Simulator(Path, Path)
    case didCreateXCFramework([Path], Path)
  }

  func testHappyPath() throws {
    let iOSPath = Path("ios/Framework.framework")
    let tvOSPath = Path("tvos/Framework.framework")
    let createdTempDir = Path("temp/path")
    let archs: [Path: [Arch]] = [
      iOSPath: [.i386, .x86_64, .armv7, .arm64],
      tvOSPath: [.x86_64, .arm64]
    ]
    let copiedFrameworks: [Path: Path] = [
      iOSPath: Path("copy/ios/Framework.framework"),
      tvOSPath: Path("copy/tvos/Framework.framework")
    ]
    var performedActions = [Action]()
    let sut = MakeXCFramework.live(
      createTempDir: .init {
        performedActions.append(.didCreateTempDir)
        return createdTempDir
      },
      getArchs: .init { path in
        performedActions.append(.didGetArchs(path))
        return archs[path]!
      },
      copyFramework: .init { input, archs, path in
        performedActions.append(.didCopyFramework(input, archs, path))
        return copiedFrameworks[input]!
      },
      addArm64Simulator: .init { device, simulator in
        performedActions.append(.didAddArm64Simulator(device, simulator))
      },
      createXCFramework: .init { frameworks, path in
        performedActions.append(.didCreateXCFramework(frameworks, path))
      }
    )
    let output = Path("output/path")

    try sut.callAsFunction(iOS: iOSPath, tvOS: tvOSPath, arm64sim: true, at: output)

    XCTAssertEqual(performedActions, [
      .didCreateTempDir,

      .didGetArchs(iOSPath),
      .didCopyFramework(iOSPath, [.armv7, .arm64], createdTempDir.addingComponent("ios-device")),
      .didCopyFramework(iOSPath, [.i386, .x86_64], createdTempDir.addingComponent("ios-simulator")),
      .didAddArm64Simulator(copiedFrameworks[iOSPath]!, copiedFrameworks[iOSPath]!),

      .didGetArchs(tvOSPath),
      .didCopyFramework(tvOSPath, [.arm64], createdTempDir.addingComponent("tvos-device")),
      .didCopyFramework(tvOSPath, [.x86_64], createdTempDir.addingComponent("tvos-simulator")),
      .didAddArm64Simulator(copiedFrameworks[tvOSPath]!, copiedFrameworks[tvOSPath]!),

      .didCreateXCFramework([
        copiedFrameworks[iOSPath]!,
        copiedFrameworks[iOSPath]!,
        copiedFrameworks[tvOSPath]!,
        copiedFrameworks[tvOSPath]!
      ], output)
    ])
  }

  func testEmptyInputFailure() {
    let sut = MakeXCFramework.live(
      createTempDir: .init { fatalError() },
      getArchs: .init { _ in fatalError() },
      copyFramework: .init { _, _, _ in fatalError() },
      createXCFramework: .init { _, _ in fatalError() }
    )
    var catchedError: Error?

    do { try sut(iOS: nil, tvOS: nil, arm64sim: true, at: Path("")) }
    catch { catchedError = error }

    XCTAssertEqual(catchedError as? MakeXCFramework.EmptyInputError, MakeXCFramework.EmptyInputError())
  }
}
