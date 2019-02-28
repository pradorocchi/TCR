import AppKit
import TCR

class Text: NSTextView {
    weak var ruler: Ruler?
    private weak var document: Editable?
    private weak var height: NSLayoutConstraint!
    
    init(_ document: Editable) {
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
        string = document.content
        insertionPointColor = .halo
        font = .light(Settings.font)
        textContainerInset = NSSize(width: 20, height: 30)
        height = heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        height.isActive = true
        self.document = document
        adjust()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func drawInsertionPoint(in rect: NSRect, color: NSColor, turnedOn: Bool) {
        var rect = rect
        rect.size.width += 2
        super.drawInsertionPoint(in: rect, color: color, turnedOn: turnedOn)
    }
    
    override func didChangeText() {
        super.didChangeText()
        document?.content = string
        adjust()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let document = self?.document else { return }
            Side.shared.folder.save(document)
        }
    }
    
    override func updateRuler() { ruler?.setNeedsDisplay(visibleRect) }
    
    private func adjust() {
        layoutManager!.ensureLayout(for: textContainer!)
        height.constant = layoutManager!.usedRect(for: textContainer!).size.height + (textContainerInset.height * 2)
        DispatchQueue.main.async { [weak self] in self?.updateRuler() }
    }
}
