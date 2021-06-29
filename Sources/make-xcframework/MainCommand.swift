import ArgumentParser
import Foundation
import XCFrameworkMaker

struct MainCommand: ParsableCommand {
  static var makeXCFramework: MakeXCFramework = .live()

  // MARK: - ParsableCommand

  static let configuration = CommandConfiguration(
    commandName: "make-xcframework",
    abstract: "Utility for creating XCFramework from legacy fat-framework files.",
    discussion: "Use this tool to create XCFramework from legacy fat-framework files. Resulting XCFramework can be added as a dependency to your Swift Package. Optionally arm64-simulator support can be included in the resulting XCFramework, so it can be used on M1 Mac without the need to run Xcode through Rosetta.",
    helpNames: [.short, .customLong("help", withSingleDash: true)]
  )

  struct InputOptions: ParsableArguments {
    @Option(
      name: .customLong("ios", withSingleDash: true),
      help: ArgumentHelp(
        "iOS input framework path.",
        discussion: "Provide a path to the iOS fat framework that should be included in the resulting XCFramework. Eg \"path/to/iOS/Framework.framework\"",
        valueName: "path"
      ),
      completion: .file(extensions: ["framework"])
    )
    var ios: String?

    @Option(
      name: .customLong("tvos", withSingleDash: true),
      help: ArgumentHelp(
        "tvOS input framework path.",
        discussion: "Provide a path to the tvOS fat framework that should be included in the resulting XCFramework. Eg \"path/to/tvOS/Framework.framework\"",
        valueName: "path"
      ),
      completion: .file(extensions: ["framework"])
    )
    var tvos: String?

    func validate() throws {
      guard ios != nil || tvos != nil else {
        throw MakeXCFramework.EmptyInputError()
      }
    }
  }

  @OptionGroup
  var inputs: InputOptions

  @Flag(
    name: .customLong("arm64sim", withSingleDash: true),
    help: ArgumentHelp(
      "Add support for arm64 simulator.",
      discussion: "Use device-arm64 architecture slice as a simulator-arm64 architecture slice and include it the resulting XCFramework. This makes development possible on M1 Mac without using Rosetta."
    )
  )
  var arm64sim: Bool = false

  @Option(
    name: .customLong("output", withSingleDash: true),
    help: ArgumentHelp(
      "Output directory path.",
      discussion: "Provide a path to a directory where the resulting XCFramework should be created. Eg \"path/to/output/directory\"",
      valueName: "path"
    ),
    completion: .directory
  )
  var output: String

  @Flag(
    name: .customLong("verbose", withSingleDash: true),
    help: ArgumentHelp(
      "Log detailed info to standard output.",
      discussion: "When this flag is provided, detailed information about each performed action is logged to standard output."
    )
  )
  var verbose: Bool = false

  func run() throws {
    try Self.makeXCFramework(
      iOS: inputs.ios.map(Path.init(_:)),
      tvOS: inputs.tvos.map(Path.init(_:)),
      arm64sim: arm64sim,
      at: Path(output),
      verbose ? Log.live(level: .verbose) : nil
    )
  }
}
