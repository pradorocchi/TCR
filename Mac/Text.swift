import AppKit

class Text: NSTextView {
    static let shared = Text()
    override var string: String { didSet { adjust() } }
    var size = CGFloat(20) { didSet { resize() } }
    var glyps: NSRange { return layoutManager!.glyphRange(forBoundingRect: visibleRect, in: textContainer!) }
    private(set) var bold: NSFont!
    private(set) var light: NSFont!
    private weak var height: NSLayoutConstraint!
    
    private init() {
        let storage = Storage()
        super.init(frame: .zero, textContainer: {
            storage.addLayoutManager($1)
            $1.addTextContainer($0)
            $0.lineBreakMode = .byCharWrapping
            $0.widthTracksTextView = true
            return $0
        } (NSTextContainer(), Layout()) )
        translatesAutoresizingMaskIntoConstraints = false
        isContinuousSpellCheckingEnabled = true
        allowsUndo = true
        drawsBackground = false
        isRichText = false
        insertionPointColor = .halo
        textContainerInset = NSSize(width: 50, height: 30)
        height = heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        height.isActive = true
        resize()
        adjust()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
        var rect = rect
        rect.size.width += 4
        super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
    }
    
    override func didChangeText() {
        super.didChangeText()
        adjust()
    }
    
    private func adjust() {
        layoutManager!.ensureLayout(for: textContainer!)
        height.constant = layoutManager!.usedRect(for: textContainer!).size.height + (textContainerInset.height * 2)
        Ruler.shared.setNeedsDisplay(visibleRect)
    }
    
    private func resize() {
        light = .light(size)
        bold = .bold(size)
        font = light
    }
}
