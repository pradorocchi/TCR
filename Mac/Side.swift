import AppKit

class Side: NSScrollView {
    static let shared = Side()
    private weak var width: NSLayoutConstraint!
    private weak var title: Label!
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
        documentView = NSView()
        documentView!.translatesAutoresizingMaskIntoConstraints = false
        documentView!.topAnchor.constraint(equalTo: topAnchor).isActive = true
        documentView!.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
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
        
        let toggle = Button("listOff", type: .toggle, target: self, action: #selector(self.toggle(_:)))
        toggle.state = .on
        toggle.alternateImage = NSImage(named: "listOn")
        documentView!.addSubview(toggle)
        
        let button = Link(String(), background: .shade, target: self, action: #selector(select))
        documentView!.addSubview(button)
        
        let title = Label(.local("Side.select"), color: NSColor(white: 1, alpha: 0.7), font: .light(11))
        button.addSubview(title)
        self.title = title
        
        right.topAnchor.constraint(equalTo: topAnchor).isActive = true
        right.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        right.widthAnchor.constraint(equalToConstant: 1).isActive = true
        right.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        button.rightAnchor.constraint(equalTo: toggle.leftAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: toggle.centerYAnchor).isActive = true
        button.width.constant = 160
        button.height.constant = 20
        
        top.topAnchor.constraint(equalTo: toggle.bottomAnchor, constant: 5).isActive = true
        top.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        top.rightAnchor.constraint(equalTo: right.leftAnchor).isActive = true
        top.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        toggle.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        toggle.rightAnchor.constraint(equalTo: right.leftAnchor).isActive = true
        toggle.widthAnchor.constraint(equalToConstant: closed).isActive = true
        toggle.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        title.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) { return nil }
    
    @objc private func toggle(_ button: Button) {
        width.constant = button.state == .on ? open : closed
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.6
            context.allowsImplicitAnimation = true
            App.shared.contentView!.layoutSubtreeIfNeeded()
        }) { }
    }
    
    @objc private func select() {
        print("select")
        
        /*
         NSURL *url = <#A URL for a directory#>;
         NSError *error = nil;
         NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
         NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
         
         NSArray *array = [[NSFileManager defaultManager]
         contentsOfDirectoryAtURL:url
         includingPropertiesForKeys:properties
         options:(NSDirectoryEnumerationSkipsHiddenFiles)
         error:&error];
         if (array == nil) {
         // Handle the error
         }

 */
    }
}
