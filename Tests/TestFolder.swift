import XCTest
@testable import TCR

class TestFolder: XCTestCase {
    private var storage: TestStorage!
    private var folder: Folder!
    private var editable: Editable!
    
    override func setUp() {
        storage = TestStorage()
        Storage.shared = storage
        folder = Folder()
        editable = Editable(URL(fileURLWithPath: "file.json"))
        folder.timeout = 0
    }
    
    func testSaveUpdates() {
        let expect = expectation(description: String())
        storage.saved = {
            XCTAssertTrue(self.folder.queue.isEmpty)
            expect.fulfill()
        }
        folder.save(editable)
        waitForExpectations(timeout: 1)
    }
    
    func testSaveAll() {
        var count = 0
        let expect = expectation(description: String())
        storage.saved = {
            count += 1
            if count == 2 {
                expect.fulfill()
            }
        }
        folder.save(editable)
        folder.save(Editable(URL(fileURLWithPath: "file.json")))
        waitForExpectations(timeout: 1)
    }
    
    func testReplaceOnSave() {
        folder.timeout = 1000
        folder.save(editable)
        folder.save(editable)
        XCTAssertEqual(1, folder.queue.count)
    }
}
