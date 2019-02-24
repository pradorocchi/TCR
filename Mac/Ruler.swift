import AppKit

class Ruler: NSRulerView {
    static let shared = Ruler()
    
    private init() {
        super.init(scrollView: nil, orientation: .verticalRuler)
        ruleThickness = 50
    }
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    
    override func draw(_: NSRect) {
        var numbers = [(Int, CGFloat)]()
        let range = Text.shared.layoutManager!.glyphRange(forBoundingRect: Text.shared.visibleRect, in: Text.shared.textContainer!)
        var line = (try! NSRegularExpression(pattern: "\n")).numberOfMatches(in: Text.shared.string, range: NSMakeRange(0, range.location)) + 1
        var current = range.lowerBound
        while current < range.upperBound {
            
            var effectiveRange = NSMakeRange(0, 0)
            let lineRect = Text.shared.layoutManager!.lineFragmentRect(forGlyphAt: current, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
            
            drawLineNumber(lineNumberString:"\(line)", y:lineRect.minY)
            
            current = NSMaxRange(Text.shared.layoutManager!.glyphRange(
                forCharacterRange: (Text.shared.string as NSString).lineRange(
                    for: NSMakeRange( Text.shared.layoutManager!.characterIndexForGlyph(at: current), 0 )
            ), actualCharacterRange: nil))
            line += 1
        }
        if Text.shared.layoutManager?.extraLineFragmentTextContainer != nil {
            drawLineNumber(lineNumberString:"\(line)", y:Text.shared.layoutManager!.extraLineFragmentRect.minY)
        }
    }
    
    override func drawHashMarksAndLabels(in: NSRect) { }
    
    private func drawLineNumber(lineNumberString:String, y:CGFloat) {
        let attString = NSAttributedString(string: lineNumberString, attributes: [.foregroundColor: NSColor(white: 1, alpha: 0.6), .font: NSFont.light(12)])
        let x = 35 - attString.size().width
        attString.draw(at: NSPoint(x: x, y: convert(NSZeroPoint, from: Text.shared).y + y + Text.shared.textContainerInset.height))
    }
}
