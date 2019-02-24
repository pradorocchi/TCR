import AppKit

class Scroll: NSScrollView {
    static let shared = Scroll()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        drawsBackground = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        verticalScrollElasticity = .allowed
        horizontalScrollElasticity = .none
        documentView = Text.shared
        verticalRulerView = Ruler.shared
        rulersVisible = true
        
        Ruler.shared.scrollView = self
        Text.shared.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        Text.shared.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
