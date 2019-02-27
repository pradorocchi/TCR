import Foundation

public class Editable: Document {
    public var content = String()
    public let name: String
    let url: URL
    
    init(_ url: URL) {
        content = Storage.shared.document(url)
        name = url.lastPathComponent
        self.url = url
    }
}
