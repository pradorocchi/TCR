import AppKit

class Text: NSTextView {
    static let shared = Text()
    override var string: String { didSet { adjust() } }
    private weak var height: NSLayoutConstraint!
    
    private init() {
        super.init(frame: .zero, textContainer: {
            Storage.shared.addLayoutManager(Layout.shared)
            Layout.shared.addTextContainer($0)
            $0.lineBreakMode = .byCharWrapping
            $0.widthTracksTextView = true
            return $0
        } (NSTextContainer()) )
        translatesAutoresizingMaskIntoConstraints = false
        allowsUndo = true
        drawsBackground = false
        isRichText = false
        insertionPointColor = .halo
        textContainerInset = NSSize(width: 20, height: 30)
        height = heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        height.isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override var font: NSFont? { didSet {
        Storage.shared.light = .light(font!.pointSize)
        Storage.shared.bold = .bold(font!.pointSize)
    } }
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
        var rect = rect
        rect.size.width += 2
        super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
    }
    
    override func didChangeText() {
        super.didChangeText()
        adjust()
    }
    
    private func adjust() {
        layoutManager!.ensureLayout(for: textContainer!)
        height.constant = layoutManager!.usedRect(for: textContainer!).size.height + (textContainerInset.height * 2)
        DispatchQueue.main.async { Ruler.shared.setNeedsDisplay(self.visibleRect) }
    }
}
