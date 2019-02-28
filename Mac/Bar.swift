import AppKit

class Bar: NSView {
    static let shared = Bar()
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let toggle = Button("listOff", type: .toggle, target: Side.shared, action: #selector(Side.shared.toggle(_:)))
        toggle.state = .on
        toggle.alternateImage = NSImage(named: "listOn")
        toggle.keyEquivalent = "l"
        toggle.keyEquivalentModifierMask = .command
        addSubview(toggle)
        
        widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        toggle.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        toggle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        toggle.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        toggle.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
