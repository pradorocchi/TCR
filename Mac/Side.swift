import AppKit
import TCR

class Side: NSScrollView {
    static let shared = Side()
    weak var selected: Document? { didSet { oldValue?.update(); selected?.update() } }
    let folder = Folder()
    private weak var width: NSLayoutConstraint!
    private weak var link: Link!
    private let open = CGFloat(240)
    private let closed = CGFloat(70)
    
    private init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        drawsBackground = false
        hasVerticalScroller = true
        verticalScroller!.controlSize = .mini
        verticalScrollElasticity = .allowed
        horizontalScrollElasticity = .none
        documentView = Flipped()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
        documentView!.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        documentView!.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        width = widthAnchor.constraint(equalToConstant: open)
        width.isActive = true
        
        let toggle = Button("listOff", type: .toggle, target: self, action: #selector(self.toggle(_:)))
        toggle.state = .on
        toggle.alternateImage = NSImage(named: "listOn")
        toggle.keyEquivalent = "l"
        toggle.keyEquivalentModifierMask = .command
        documentView!.addSubview(toggle)
        
        let link = Link(String(), background: .red, target: self, action: #selector(select))
        link.keyEquivalent = "o"
        link.alignment = .left
        link.keyEquivalentModifierMask = .command
        documentView!.addSubview(link)
        self.link = link
        
        link.rightAnchor.constraint(equalTo: toggle.leftAnchor).isActive = true
        link.centerYAnchor.constraint(equalTo: toggle.centerYAnchor).isActive = true
        link.width.constant = 154
        link.height.constant = 40
        
        toggle.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        toggle.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        toggle.widthAnchor.constraint(equalToConstant: closed).isActive = true
        toggle.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        documentView!.subviews.filter({ $0 is Document }).forEach({ $0.removeFromSuperview() })
        link.attributedTitle = NSAttributedString(string: App.shared.user.folder ?? .local("Side.select"), attributes:
            [.font: NSFont.systemFont(ofSize: 14, weight: .bold), .foregroundColor: NSColor(white: 1, alpha: 0.7)])
        folder.documents(App.shared.user) {
            var top = self.topAnchor
            $0.enumerated().forEach {
                let document = Document($0.1)
                self.documentView!.addSubview(document)
                
                document.widthAnchor.constraint(equalToConstant: self.open).isActive = true
                document.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -self.closed).isActive = true
                document.topAnchor.constraint(equalTo: top, constant: $0.0 == 0 ? 80 : 0).isActive = true
                top = document.bottomAnchor
            }
            if self.topAnchor !== top {
                self.documentView!.bottomAnchor.constraint(equalTo: top, constant: 20).isActive = true
            }
        }
    }
    
    @objc func open(_ item: Document) {
        guard item !== selected else { return }
        selected = item
        Scroll.shared.open(item.document)
    }
    
    @objc private func toggle(_ button: Button) {
        width.constant = button.state == .on ? open : closed
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) { }
    }
    
    @objc private func select() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.message = .local("Side.open")
        panel.begin {
            if $0 == .OK {
                App.shared.user.bookmark = [panel.url!: try! panel.url!.bookmarkData(options: .withSecurityScope)]
                self.update()
            }
        }
    }
}

private class Flipped: NSView { override var isFlipped: Bool { return true } }
