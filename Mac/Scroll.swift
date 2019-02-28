import AppKit
import TCR

class Scroll: NSScrollView {
    static let shared = Scroll()
    
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
        switch document {
        case let document as Directory: configure(document)
        case let document as Editable: configure(document)
        default: break
        }
    }
    
    private func configure(_ document: Editable) {
        let text = Text(document)
        let ruler = Ruler(text, layout: text.layoutManager as! Layout)
        text.ruler = ruler
        documentView = text
        verticalRulerView = ruler
        rulersVisible = true
        verticalScrollElasticity = .allowed
        
        text.widthAnchor.constraint(equalTo: widthAnchor, constant: -ruler.ruleThickness).isActive = true
        text.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
    }
    
    private func configure(_ document: Directory) {
        documentView = NSView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        verticalRulerView = nil
        rulersVisible = false
        verticalScrollElasticity = .none
        
        let label = Label(document.name, color: NSColor(white: 1, alpha: 0.5), font:
            .systemFont(ofSize: 30, weight: .bold), align: .center)
        documentView!.addSubview(label)
        
        documentView!.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        documentView!.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
