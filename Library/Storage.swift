import Foundation

class Storage {
    static var shared = Storage()
    private let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private var _user: URL { return url("User") }
    
    func user() throws -> User { return try JSONDecoder().decode(User.self, from: try Data(contentsOf: _user)) }
    func save(_ user: User) { try! (try! JSONEncoder().encode(user)).write(to: _user, options: .atomic) }
    private func url(_ id: String) -> URL { return url.appendingPathComponent(id + ".tcr") }
}
