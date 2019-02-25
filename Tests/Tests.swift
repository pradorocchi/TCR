import XCTest
@testable import TCR

class Tests: XCTestCase {
    private var storage: TestStorage!
    
    override func setUp() {
        storage = TestStorage()
        Storage.shared = storage
    }
    
    func testFirstTime() {
        storage.error = NSError()
        XCTAssertNotNil(User.load())
        XCTAssertLessThanOrEqual(Date(), User.load().created)
    }
    
    func testLoad() {
        
    }
}
