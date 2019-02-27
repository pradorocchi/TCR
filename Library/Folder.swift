import Foundation

public class Folder {
    public var queue = [Editable]() { didSet { schedule() } }
    var timeout = TimeInterval(3)
    private let timer = DispatchSource.makeTimerSource(queue: .global(qos: .background))
    
    public init() {
        timer.resume()
        timer.setEventHandler { [weak self] in self?.fire() }
    }
    
    public func documents(_ user: User) -> [Document] {
        return user.bookmark.isEmpty ? [] : load(
            (try! FileManager.default.contentsOfDirectory(at: user.bookmark.first!.0, includingPropertiesForKeys: [])))
    }
    
    func load(_ url: [URL]) -> [Document] {
        return url.map ({
            (try? $0.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true ? Directory($0) : {
                switch $0.pathExtension {
                case "md": return Md($0)
                default: return Editable($0)
                }
            } ($0) as Document }).sorted(by: {
                $0 is Directory && !($1 is Directory) ? false :
                    $1 is Directory && !($0 is Directory) ? true :
                        $0.name.compare($1.name, options: .caseInsensitive) == .orderedAscending
            })
    }
    
    private func schedule(_ time: DispatchTime? = nil) { timer.schedule(deadline: time ?? .now() + timeout) }
    
    private func fire() {
        Storage.shared.save(queue.removeFirst())
        queue.isEmpty ? schedule(.distantFuture) : schedule()
    }
}
