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
        verticalScrollElasticity = .allowed
        
        text.widthAnchor.constraint(equalTo: widthAnchor, constant: -ruler.ruleThickness).isActive = true
        text.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
    }
    
    private func configureDirectory() {
        documentView = NSView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        verticalRulerView = nil
        rulersVisible = false
        verticalScrollElasticity = .none
        
        let label = Label(document.content, color: NSColor(white: 1, alpha: 0.5), font:
            .systemFont(ofSize: 30, weight: .bold), align: .center)
        documentView!.addSubview(label)
        
        documentView!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        documentView!.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
