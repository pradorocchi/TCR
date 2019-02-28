import Foundation

public class Image: Document {
    public let url: URL
    public let name: String
    
    init(_ url: URL) {
        name = url.lastPathComponent
        self.url = url
    }
}
