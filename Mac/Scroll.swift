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
        isHidden = true
        documentView = Text.shared
        verticalRulerView = Ruler.shared
        rulersVisible = true
        
        Ruler.shared.scrollView = self
        Text.shared.widthAnchor.constraint(equalTo: widthAnchor, constant: -Ruler.shared.ruleThickness).isActive = true
        Text.shared.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func open(_ url: URL) {
        documentView!.scrollToVisible(.zero)
        Text.shared.string = String(decoding: try! Data(contentsOf: url, options: Data.ReadingOptions.alwaysMapped), as: UTF8.self)
        isHidden = false
    }
}
