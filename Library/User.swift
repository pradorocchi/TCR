import Foundation

public class User: Codable {
    public let created = Date()
    
    class func load() -> User {
        return (try? Storage.shared.user()) ?? User()
    }
}
