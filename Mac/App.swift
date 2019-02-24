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
        contentView!.addSubview(Scroll.shared)
        
        Scroll.shared.topAnchor.constraint(equalTo: contentView!.topAnchor).isActive = true
        Scroll.shared.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        Scroll.shared.leftAnchor.constraint(equalTo: contentView!.leftAnchor).isActive = true
        Scroll.shared.rightAnchor.constraint(equalTo: contentView!.rightAnchor).isActive = true
    }
}
