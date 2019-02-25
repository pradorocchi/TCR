import AppKit

class Side: NSScrollView {
    static let shared = Side()
    private weak var width: NSLayoutConstraint!
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        drawsBackground = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        verticalScrollElasticity = .allowed
        horizontalScrollElasticity = .none
        documentView = NSView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
        documentView!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        documentView!.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        documentView!.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        width = widthAnchor.constraint(equalToConstant: 200)
        width.isActive = true
        
        let border = NSView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.wantsLayer = true
        border.layer!.backgroundColor = NSColor(white: 1, alpha: 0.2).cgColor
        documentView!.addSubview(border)
        
        border.topAnchor.constraint(equalTo: topAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        border.widthAnchor.constraint(equalToConstant: 1).isActive = true
        border.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
