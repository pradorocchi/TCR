import AppKit
import TCR

class Document: NSControl {
    let document: TCR.Document
    
    init(_ document: TCR.Document, target: AnyObject, action: Selector) {
        self.document = document
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        self.target = target
        self.action = action
        
        let label = Label(document.name, color: NSColor(white: 1, alpha: 0.7), font: .light(12))
        label.lineBreakMode = .byCharWrapping
        label.maximumNumberOfLines = 2
        addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        update()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    override func mouseDown(with: NSEvent) { sendAction(action, to: target) }
    
    func update() {
        layer!.backgroundColor = Side.shared.selected === self ? NSColor.shade.cgColor : nil
    }
}
