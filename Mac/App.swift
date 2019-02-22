import AppKit

@NSApplicationMain class App: NSWindow, NSApplicationDelegate {
    static private(set) weak var shared: App!
    
    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool { return true }
    override func cancelOperation(_: Any?) { makeFirstResponder(nil) }
    override func mouseDown(with: NSEvent) { makeFirstResponder(nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
        backgroundColor = .black
        NSApp.delegate = self
        App.shared = self
        
        let scroll = NSScrollView()
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = true
        scroll.hasHorizontalScroller = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.verticalScrollElasticity = .allowed
        scroll.horizontalScrollElasticity = .allowed
        scroll.documentView = NSView()
        scroll.documentView!.translatesAutoresizingMaskIntoConstraints = false
        contentView!.addSubview(scroll)
        
        let text = Text()
        text.string = "hello world"
        scroll.documentView!.addSubview(text)
        
        scroll.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
        
        scroll.documentView!.topAnchor.constraint(equalTo: scroll.topAnchor).isActive = true
        scroll.documentView!.leftAnchor.constraint(equalTo: scroll.leftAnchor).isActive = true
        scroll.documentView!.bottomAnchor.constraint(equalTo: text.bottomAnchor).isActive = true
        scroll.documentView!.rightAnchor.constraint(equalTo: text.rightAnchor).isActive = true
        
        text.topAnchor.constraint(equalTo: scroll.documentView!.topAnchor).isActive = true
        text.leftAnchor.constraint(equalTo: scroll.documentView!.leftAnchor).isActive = true
        text.widthAnchor.constraint(greaterThanOrEqualTo: scroll.widthAnchor).isActive = true
        text.heightAnchor.constraint(greaterThanOrEqualTo: scroll.heightAnchor).isActive = true
    }
}
