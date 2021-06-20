import Foundation

public struct Path: Equatable, Hashable {
  public init(_ string: String) {
    self.string = string
  }

  var string: String
}

extension Path {
  var lastComponent: String {
    string.split(separator: "/").last.map(String.init) ?? ""
  }

  var fileExtension: String? {
    let lastComponent = self.lastComponent
    guard lastComponent.contains(".") else { return nil }
    return lastComponent.split(separator: ".").last.map(String.init)
  }

  var filenameExcludingExtension: String {
    let lastComponent = self.lastComponent
    guard lastComponent.contains(".") else { return lastComponent }
    var filenameComponents = lastComponent.split(separator: ".").map(String.init)
    guard filenameComponents.count > 1 else { return lastComponent }
    filenameComponents.removeLast()
    return filenameComponents.joined(separator: ".")
  }

  func addingComponent(_ component: String) -> Path {
    var newString = string
    if newString.hasSuffix("/") == false {
      newString.append("/")
    }
    newString.append(component)
    return Path(newString)
  }
}
