import XCTest
@testable import TCR

class TestDocument: XCTestCase {
    private var folder: Folder!
    
    override func setUp() {
        folder = Folder()
    }
    
    func testMakeDirectory() {
        XCTAssertTrue(folder.make([URL(fileURLWithPath: NSHomeDirectory())]).first is Directory)
        XCTAssertFalse(folder.make([URL(fileURLWithPath: "hello.world")]).first is Directory)
    }
    
    func testMd() {
        XCTAssertTrue(folder.make([URL(fileURLWithPath: "hello.md")]).first is Md)
    }
    
    func testName() {
        XCTAssertEqual("hello.md", folder.make([URL(fileURLWithPath: "is/fake/hello.md")]).first?.name)
    }
    
    func testSort() {
        let documents = folder.make([URL(fileURLWithPath: "b"), URL(fileURLWithPath: "a")])
        XCTAssertEqual("a", documents.first?.name)
        XCTAssertEqual("b", documents.last?.name)
    }
}
