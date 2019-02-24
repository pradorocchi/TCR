import AppKit

class Ruler: NSRulerView {
    static let shared = Ruler()
    
    private init() {
        super.init(scrollView: nil, orientation: .verticalRuler)
        ruleThickness = 50
    }
    
    required init(coder: NSCoder) { super.init(coder: coder) }
    
    override func draw(_ rect: NSRect) {
        let range = Text.shared.layoutManager!.glyphRange(forBoundingRect: Text.shared.visibleRect,
                                                          in: Text.shared.textContainer!)
        var line = (try! NSRegularExpression(pattern: "\n")).numberOfMatches(in: Text.shared.string, options: [], range: NSMakeRange(0, Text.shared.layoutManager!.characterIndexForGlyph(at: range.location))) + 1
        var current = range.lowerBound
        while current < range.upperBound {
            
            let characterRangeForStringLine = (Text.shared.string as NSString).lineRange(
                for: NSMakeRange( Text.shared.layoutManager!.characterIndexForGlyph(at: current), 0 )
            )
            let glyphRangeForStringLine = Text.shared.layoutManager!.glyphRange(forCharacterRange: characterRangeForStringLine, actualCharacterRange: nil)
            
            var glyphIndexForGlyphLine = current
            var glyphLineCount = 0
            
            while ( glyphIndexForGlyphLine < NSMaxRange(glyphRangeForStringLine) ) {
                
                // See if the current line in the string spread across
                // several lines of glyphs
                var effectiveRange = NSMakeRange(0, 0)
                
                // Range of current "line of glyphs". If a line is wrapped,
                // then it will have more than one "line of glyphs"
                let lineRect = Text.shared.layoutManager!.lineFragmentRect(forGlyphAt: glyphIndexForGlyphLine, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
                
                if glyphLineCount > 0 {
                    drawLineNumber(lineNumberString:"-", y:lineRect.minY)
                } else {
                    drawLineNumber(lineNumberString:"\(line)", y:lineRect.minY)
                }
                
                // Move to next glyph line
                glyphLineCount += 1
                glyphIndexForGlyphLine = NSMaxRange(effectiveRange)
            }
            
            current = NSMaxRange(glyphRangeForStringLine)
            line += 1
        }
        /*
        Text.shared.layoutManager?.glyphRange(forBoundingRectWithoutAdditionalLayout: <#T##NSRect#>, in: <#T##NSTextContainer#>)
        
        
        
       let visibleGlyphRange = Text.shared.layoutManager!.glyphRange(forBoundingRect: Text.shared.visibleRect,
                                                                     in: Text.shared.textContainer!)
        let firstVisibleGlyphCharacterIndex = layoutManager.characterIndexForGlyph(at: visibleGlyphRange.location)
        
        let newLineRegex = try! NSRegularExpression(pattern: "\n", options: [])
        // The line number for the first visible line
        var lineNumber = newLineRegex.numberOfMatches(in: textView.string, options: [], range: NSMakeRange(0, firstVisibleGlyphCharacterIndex)) + 1
        
        var glyphIndexForStringLine = visibleGlyphRange.location
        
        // Go through each line in the string.
        while glyphIndexForStringLine < NSMaxRange(visibleGlyphRange) {
            
            // Range of current line in the string.
            let characterRangeForStringLine = (textView.string as NSString).lineRange(
                for: NSMakeRange( layoutManager.characterIndexForGlyph(at: glyphIndexForStringLine), 0 )
            )
            let glyphRangeForStringLine = layoutManager.glyphRange(forCharacterRange: characterRangeForStringLine, actualCharacterRange: nil)
            
            var glyphIndexForGlyphLine = glyphIndexForStringLine
            var glyphLineCount = 0
            
            while ( glyphIndexForGlyphLine < NSMaxRange(glyphRangeForStringLine) ) {
                
                // See if the current line in the string spread across
                // several lines of glyphs
                var effectiveRange = NSMakeRange(0, 0)
                
                // Range of current "line of glyphs". If a line is wrapped,
                // then it will have more than one "line of glyphs"
                let lineRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndexForGlyphLine, effectiveRange: &effectiveRange, withoutAdditionalLayout: true)
                
                if glyphLineCount > 0 {
                    drawLineNumber("-", lineRect.minY)
                } else {
                    drawLineNumber("\(lineNumber)", lineRect.minY)
                }
                
                // Move to next glyph line
                glyphLineCount += 1
                glyphIndexForGlyphLine = NSMaxRange(effectiveRange)
            }
            
            glyphIndexForStringLine = NSMaxRange(glyphRangeForStringLine)
            lineNumber += 1
        }*/
        
        drawLineNumber(lineNumberString:"\(line)", y:Text.shared.layoutManager!.extraLineFragmentRect.minY)
    }
    
    override func drawHashMarksAndLabels(in: NSRect) { }
    
    private func drawLineNumber(lineNumberString:String, y:CGFloat) {
        let attString = NSAttributedString(string: lineNumberString, attributes: [.foregroundColor:NSColor.white])
        let x = 35 - attString.size().width
        attString.draw(at: NSPoint(x: x, y: convert(NSZeroPoint, from: Text.shared).y + y + 50))
    }
}
