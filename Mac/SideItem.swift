import AppKit

class SideItem: NSControl {
    init(_ url: URL, target: AnyObject, action: Selector) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        self.target = target
        self.action = action
        
        let label = Label(url.lastPathComponent, color: NSColor(white: 1, alpha: 0.5), font: .light(12))
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
