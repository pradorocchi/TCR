import Foundation

public class Document {
    class func make(_ url: [URL]) -> [Document] {
        return url.map {
            (try? $0.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true ? Directory($0) : {
                switch $0.pathExtension {
                case "md": return Md($0)
                default: return Document($0)
                }
            } ($0) as Document
        }
    }
    
    public let name: String
    
    init(_ url: URL) {
        name = url.lastPathComponent
    }
}
