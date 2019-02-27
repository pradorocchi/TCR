import AppKit
import TCR

class Document: NSControl {
    let document: TCR.Document
    private weak var label: Label!
    
    init(_ document: TCR.Document) {
        self.document = document
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        
        let label = Label(document.name, font: .systemFont(ofSize: 12, weight: .light))
        label.lineBreakMode = .byCharWrapping
        label.maximumNumberOfLines = 2
        addSubview(label)
        self.label = label
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        update()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func mouseDown(with: NSEvent) { sendAction(#selector(Side.shared.open(_:)), to: Side.shared) }
    
    func update() {
        if Side.shared.selected === self {
            layer!.backgroundColor = NSColor.shade.cgColor
            label.alphaValue = 0.9
        } else {
            layer!.backgroundColor = nil
            label.alphaValue = 0.7
        }
    }
}
