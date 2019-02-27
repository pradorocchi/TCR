import Foundation

public class Directory: Document {
    public let name: String
    
    init(_ url: URL) {
        name = url.lastPathComponent + "/"
    }
}
