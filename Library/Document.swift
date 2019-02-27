import Foundation

public class Document {
    class func make(_ url: [URL]) -> [Document] {
        return url.map ({
            (try? $0.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true ? Directory($0) : {
                switch $0.pathExtension {
                case "md": return Md($0)
                default: return Document($0)
                }
            } ($0) as Document }).sorted(by: { $0.name.compare($1.name, options: .caseInsensitive) == .orderedAscending })
    }
    
    public var editable: Bool { return true }
    public var ruler: Bool { return true }
    public var name: String { return url.lastPathComponent }
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
    
    public var content: String {
        return {
            $0 == nil ? String() : String(decoding: $0!, as: UTF8.self)
        } (try? Data(contentsOf: url, options: .alwaysMapped))
    }
}
