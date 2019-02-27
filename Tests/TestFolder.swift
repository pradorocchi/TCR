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
        folder.queue.append(editable)
        waitForExpectations(timeout: 1)
    }
    
    func testSaveAll() {
        let expectFirst = expectation(description: String())
        let expectSecond = expectation(description: String())
        storage.saved = {
            if self.folder.queue.isEmpty {
                expectSecond.fulfill()
            } else {
                expectFirst.fulfill()
            }
        }
        folder.queue.append(editable)
        folder.queue.append(Editable(URL(fileURLWithPath: "file.json")))
        waitForExpectations(timeout: 1)
    }
}
