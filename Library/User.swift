import Foundation

public class User: Codable {
    public var bookmark = [URL: Data]() { didSet { save() } }
    public let created = Date()
    
    public class func load() -> User {
        return { $0 == nil ? {
            $0.save()
            return $0
            } (User()) : $0!
        } (try? Storage.shared.user())
    }
    
    private func save() { Storage.shared.save(self) }
}
