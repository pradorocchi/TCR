import AppKit

class Ruler: NSRulerView {
    static let shared = Ruler()
    
    private init() {
        super.init(scrollView: nil, orientation: .verticalRuler)
        ruleThickness = 40
    }
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    
    override func draw(_: NSRect) {
        var numbers = [(Int, CGFloat)]()
        let range = Layout.shared.glyphRange(forBoundingRect: Text.shared.visibleRect, in: Text.shared.textContainer!)
        var i = (try! NSRegularExpression(pattern: "\n")).numberOfMatches(in: Text.shared.string,
                                                                          range: NSMakeRange(0, range.location))
        var c = range.lowerBound
        while c < range.upperBound {
            i += 1
            numbers.append((i, Layout.shared.lineFragmentRect(forGlyphAt: c, effectiveRange: nil,
                                                              withoutAdditionalLayout: true).minY))
            
            c = Layout.shared.glyphRange(forCharacterRange: NSRange(location: Text.shared.string.lineRange(for:
                Range(NSRange(location: c, length: 0), in: Text.shared.string)!).upperBound.encodedOffset, length: 0),
                                         actualCharacterRange: nil).upperBound
        }
        if Layout.shared.extraLineFragmentTextContainer != nil {
            numbers.append((i + 1, Layout.shared.extraLineFragmentRect.minY))
        }
        let y = convert(NSZeroPoint, from: Text.shared).y + Text.shared.textContainerInset.height + Layout.shared.padding
        numbers.map({ (NSAttributedString(string: String($0.0), attributes:
            [.foregroundColor: NSColor(white: 1, alpha: 0.4), .font: NSFont.light(14)]), $0.1) })
            .forEach { $0.0.draw(at: CGPoint(x: ruleThickness - $0.0.size().width, y: $0.1 + y)) }
    }
    
    override func drawHashMarksAndLabels(in: NSRect) { }
}
