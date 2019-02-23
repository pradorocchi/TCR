import AppKit

class Text:NSTextView {
    static let shared = Text()
    private weak var height:NSLayoutConstraint!
    override var string:String { didSet { adjustConstraints() } }
    
    private init() {
        let container = NSTextContainer()
        let storage = Storage()
        let layout = Layout()
        storage.addLayoutManager(layout)
        layout.addTextContainer(container)
        container.lineBreakMode = .byCharWrapping
        container.widthTracksTextView = true
        super.init(frame:.zero, textContainer:container)
        translatesAutoresizingMaskIntoConstraints = false
        isContinuousSpellCheckingEnabled = true
        allowsUndo = true
        drawsBackground = false
        isRichText = false
        insertionPointColor = .halo
        textContainerInset = NSSize(width: 50, height: 30)
        font = .light(32)
        height = heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        height.isActive = true
        adjustConstraints()
    }
    
    required init?(coder:NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect:NSRect, color:NSColor, turnedOn:Bool) {
        var rect = rect
        rect.size.width += 4
        super.drawInsertionPoint(in:rect, color:color, turnedOn:turnedOn)
    }
    
    override func didChangeText() {
        super.didChangeText()
        adjustConstraints()
    }
    
    private func adjustConstraints() {
        layoutManager!.ensureLayout(for:textContainer!)
        height.constant = layoutManager!.usedRect(for:textContainer!).size.height + (textContainerInset.height * 2)
    }
}
