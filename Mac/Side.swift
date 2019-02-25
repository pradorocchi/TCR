import AppKit

class Side: NSScrollView {
    static let shared = Side()
    private weak var width: NSLayoutConstraint!
    private weak var top: NSView!
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
        
        let right = NSView()
        right.translatesAutoresizingMaskIntoConstraints = false
        right.wantsLayer = true
        right.layer!.backgroundColor = NSColor.shade.cgColor
        documentView!.addSubview(right)
        
        let top = NSView()
        top.translatesAutoresizingMaskIntoConstraints = false
        top.wantsLayer = true
        top.layer!.backgroundColor = right.layer!.backgroundColor
        documentView!.addSubview(top)
        self.top = top
        
        let toggle = Button("listOff", type: .toggle, target: self, action: #selector(self.toggle(_:)))
        toggle.state = .on
        toggle.alternateImage = NSImage(named: "listOn")
        toggle.keyEquivalent = "l"
        toggle.keyEquivalentModifierMask = .command
        documentView!.addSubview(toggle)
        
        let link = Link(.local("Side.select"), background: .clear, target: self, action: #selector(select))
        link.keyEquivalent = "o"
        link.alignment = .left
        link.keyEquivalentModifierMask = .command
        documentView!.addSubview(link)
        self.link = link
        
        right.topAnchor.constraint(equalTo: topAnchor).isActive = true
        right.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        right.widthAnchor.constraint(equalToConstant: 1).isActive = true
        right.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        link.rightAnchor.constraint(equalTo: toggle.leftAnchor).isActive = true
        link.centerYAnchor.constraint(equalTo: toggle.centerYAnchor).isActive = true
        link.width.constant = 160
        link.height.constant = 20
        
        top.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: 5).isActive = true
        top.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        top.rightAnchor.constraint(equalTo: right.leftAnchor).isActive = true
        top.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        toggle.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        toggle.rightAnchor.constraint(equalTo: right.leftAnchor).isActive = true
        toggle.widthAnchor.constraint(equalToConstant: closed).isActive = true
        toggle.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    func update() {
        guard let bookmark = App.shared.user.bookmark.first else { return }
        documentView!.subviews.filter({ $0 is SideItem }).forEach({ $0.removeFromSuperview() })
        var stale = false
        _ = (try! URL(resolvingBookmarkData: bookmark.1, options: .withSecurityScope, bookmarkDataIsStale: &stale))
            .startAccessingSecurityScopedResource()
        link.attributedTitle = NSAttributedString(string: bookmark.0.lastPathComponent, attributes:
            [.font: NSFont.bold(14), .foregroundColor: NSColor.white])
        var top = self.top.bottomAnchor
        (try! FileManager.default.contentsOfDirectory(at: bookmark.0, includingPropertiesForKeys: [])).forEach {
            let item = SideItem($0)
            documentView!.addSubview(item)
            
            item.widthAnchor.constraint(equalToConstant: open).isActive = true
            item.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            item.topAnchor.constraint(equalTo: top).isActive = true
            top = item.bottomAnchor
        }
        if self.top.bottomAnchor != top {
            documentView!.bottomAnchor.constraint(equalTo: top, constant: 20).isActive = true
        }
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
        let open = NSOpenPanel()
        open.canChooseFiles = false
        open.canChooseDirectories = true
        open.message = .local("Side.open")
        open.begin {
            if $0 == .OK {
                App.shared.user.bookmark = [open.url!: try! open.url!.bookmarkData(options: .withSecurityScope)]
                self.update()
            }
        }
    }
}

private class Flipped: NSView { override var isFlipped: Bool { return true } }
