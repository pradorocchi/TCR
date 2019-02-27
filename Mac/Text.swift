import AppKit

class Text: NSTextView {
    override var string: String { didSet { adjust() } }
    weak var ruler: Ruler?
    private weak var height: NSLayoutConstraint!
    
    init() {
        let storage = Storage()
        super.init(frame: .zero, textContainer: {
            storage.addLayoutManager($1)
            $1.addTextContainer($0)
            $0.lineBreakMode = .byCharWrapping
            $0.widthTracksTextView = true
            return $0
        } (NSTextContainer(), Layout()) )
        translatesAutoresizingMaskIntoConstraints = false
        allowsUndo = true
        drawsBackground = false
        isRichText = false
        insertionPointColor = .halo
        font = .light(Settings.font)
        textContainerInset = NSSize(width: 20, height: 30)
        height = heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        height.isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
        var rect = rect
        rect.size.width += 2
        super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
    }
    
    override func didChangeText() {
        super.didChangeText()
        adjust()
    }
    
    override func updateRuler() { ruler?.setNeedsDisplay(visibleRect) }
    
    private func adjust() {
        layoutManager!.ensureLayout(for: textContainer!)
        height.constant = layoutManager!.usedRect(for: textContainer!).size.height + (textContainerInset.height * 2)
        DispatchQueue.main.async { [weak self] in self?.updateRuler() }
    }
}
