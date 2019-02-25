import Foundation
@testable import TCR

class TestStorage: Storage {
    var error: Error?
    var _user = User()
    var saved: (() -> Void)?
    
    override func user() throws -> User {
        if let error = self.error {
            throw error
        }
        return _user
    }
    
    override func save(_ user: User) {
        saved?()
    }
}
