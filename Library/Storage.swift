import Foundation

class Storage {
    static var shared = Storage()
    private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let queue = DispatchQueue(label: String(), qos: .background, target: .global(qos: .background))
    private var _user: URL { return url("User") }
    
    func save(_ user: User) {
        queue.async { try! (try! JSONEncoder().encode(user)).write(to: self._user, options: .atomic) }
    }
    
    func user() throws -> User { return try JSONDecoder().decode(User.self, from: try Data(contentsOf: _user)) }
    private func url(_ id: String) -> URL { return url.appendingPathComponent(id + ".tcr") }
}
