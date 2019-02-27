import AppKit
import TCR

class Scroll: NSScrollView {
    static let shared = Scroll()
    private weak var document: TCR.Document!
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        drawsBackground = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        verticalScrollElasticity = .allowed
        horizontalScrollElasticity = .none
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func open(_ document: TCR.Document) {
        self.document = document
        switch document {
        case is Directory: configureDirectory()
        default: configureDefault()
        }
    }
    
    private func configureDefault() {
        let text = Text()
        let ruler = Ruler(text, layout: text.layoutManager as! Layout)
        text.ruler = ruler
        text.string = document.content
        documentView = text
        verticalRulerView = ruler
        rulersVisible = true
        
        text.widthAnchor.constraint(equalTo: widthAnchor, constant: -ruler.ruleThickness).isActive = true
        text.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
    }
    
    private func configureDirectory() {
        documentView = NSView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        verticalRulerView = nil
        rulersVisible = false
        
        documentView!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        documentView!.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
}
