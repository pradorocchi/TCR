import Foundation

public class Document {
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
