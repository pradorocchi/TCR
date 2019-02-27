import XCTest
@testable import TCR

class TestDocument: XCTestCase {
    private var folder: Folder!
    private var storage: TestStorage!
    
    override func setUp() {
        storage = TestStorage()
        Storage.shared = storage
        folder = Folder()
    }
    
    func testLoadFromStorage() {
        storage._document = "hello world"
        XCTAssertEqual("hello world", Editable(URL(fileURLWithPath: String())).content)
    }
    
    func testMakeDirectory() {
        XCTAssertTrue(folder.load([URL(fileURLWithPath: NSHomeDirectory())]).first is Directory)
        XCTAssertFalse(folder.load([URL(fileURLWithPath: "hello.world")]).first is Directory)
    }
    
    func testMd() {
        XCTAssertTrue(folder.load([URL(fileURLWithPath: "hello.md")]).first is Md)
    }
    
    func testGeneric() {
        XCTAssertTrue(folder.load([URL(fileURLWithPath: "hello")]).first is Editable)
    }
    
    func testName() {
        XCTAssertEqual("hello.md", folder.load([URL(fileURLWithPath: "is/fake/hello.md")]).first?.name)
    }
    
    func testSort() {
        let documents = folder.load([URL(fileURLWithPath: "b"), URL(fileURLWithPath: "a")])
        XCTAssertEqual("a", documents.first?.name)
        XCTAssertEqual("b", documents.last?.name)
    }
}
