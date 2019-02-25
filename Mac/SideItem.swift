import AppKit

class SideItem: NSControl {
    init(_ url: URL) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        let label = Label(url.lastPathComponent, color: NSColor(white: 1, alpha: 0.6), font: .light(12))
        addSubview(label)
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -80).isActive = true
        
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
}
