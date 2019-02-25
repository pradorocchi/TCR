import AppKit

class Link: NSButton {
    init(_ title: String, background: NSColor = .clear, text: NSColor = .white, target: AnyObject, action: Selector) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        wantsLayer = true
        layer!.backgroundColor = background.cgColor
        layer!.cornerRadius = 6
        setButtonType(.momentaryChange)
        isBordered = false
        attributedTitle = NSAttributedString(string: title, attributes: [.font: NSFont.bold(16), .foregroundColor: text])
        widthAnchor.constraint(equalToConstant: 108).isActive = true
        heightAnchor.constraint(equalToConstant: 38).isActive = true
        self.target = target
        self.action = action
    }
    
    required init?(coder: NSCoder) { return nil }
}
