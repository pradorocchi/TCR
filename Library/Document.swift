import Foundation

public class Document {
    public var name: String { return url.lastPathComponent }
    public var content: String { return Storage.shared.document(url) }
    let url: URL
    
    init(_ url: URL) {
        self.url = url
    }
}
