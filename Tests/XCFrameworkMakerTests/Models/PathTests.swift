import XCTest
@testable import XCFrameworkMaker

final class PathTests: XCTestCase {
  func testAddingComponent() {
    XCTAssertEqual(Path("some/path").addingComponent("component").string, "some/path/component")
    XCTAssertEqual(Path("some/path/").addingComponent("component").string, "some/path/component")
  }

  func testLastComponent() {
    XCTAssertEqual(Path("some/file").lastComponent, "file")
    XCTAssertEqual(Path("some/file.extension").lastComponent, "file.extension")
    XCTAssertEqual(Path("some/directory/").lastComponent, "directory")
    XCTAssertEqual(Path("path").lastComponent, "path")
    XCTAssertEqual(Path("").lastComponent, "")
    XCTAssertEqual(Path("/").lastComponent, "")
    XCTAssertEqual(Path("//").lastComponent, "")
    XCTAssertEqual(Path("path/").lastComponent, "path")
    XCTAssertEqual(Path("path//").lastComponent, "path")
    XCTAssertEqual(Path("/path/").lastComponent, "path")
    XCTAssertEqual(Path("some/path///").lastComponent, "path")
  }

  func testFileExtension() {
    XCTAssertNil(Path("file").fileExtension)
    XCTAssertNil(Path("path/to/some/file").fileExtension)
    XCTAssertEqual(Path("file.ext").fileExtension, "ext")
    XCTAssertEqual(Path("file.name.ext").fileExtension, "ext")
    XCTAssertEqual(Path("path/to/file.ext").fileExtension, "ext")
    XCTAssertEqual(Path("/path/to/file.ext").fileExtension, "ext")
    XCTAssertEqual(Path("path/to/file.ext/").fileExtension, "ext")
    XCTAssertEqual(Path("/path/to/file.ext//").fileExtension, "ext")
  }

  func testFilenameExcludingExtension() {
    XCTAssertEqual(Path("file").filenameExcludingExtension, "file")
    XCTAssertEqual(Path("file.ext").filenameExcludingExtension, "file")
    XCTAssertEqual(Path("file.name.ext").filenameExcludingExtension, "file.name")
    XCTAssertEqual(Path("path/to/file.ext").filenameExcludingExtension, "file")
    XCTAssertEqual(Path("/path/to/file.ext").filenameExcludingExtension, "file")
    XCTAssertEqual(Path("path/to/file.ext/").filenameExcludingExtension, "file")
    XCTAssertEqual(Path("/path/to/file.ext//").filenameExcludingExtension, "file")
  }
}
