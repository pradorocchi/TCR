import Foundation

public class Folder {
    public init() { }
    
    public func documents(_ user: User) -> [Document] {
        return user.bookmark.isEmpty ? [] : make(
            (try! FileManager.default.contentsOfDirectory(at: user.bookmark.first!.0, includingPropertiesForKeys: [])))
    }
    
    func make(_ url: [URL]) -> [Document] {
        return url.map ({
            (try? $0.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true ? Directory($0) : {
                switch $0.pathExtension {
                case "md": return Md($0)
                default: return Document($0)
                }
            } ($0) as Document }).sorted(by: { $0.name.compare($1.name, options: .caseInsensitive) == .orderedAscending })
    }
}
