//
//  TerminalScreensaverView.swift
//  TerminalScreensaver
//
//  Created by Naman on 22/02/16.
//  Copyright © 2016 naman14. All rights reserved.
//

import Cocoa

import ScreenSaver

class TerminalScreensaverView: ScreenSaverView {
    
    var text: NSString? = ""
    var textStorage = NSTextStorage(string: " ");
    var layoutmanager = NSLayoutManager();
    var textContainer: NSTextContainer?
    
    
    override func drawRect(dirtyRect: NSRect) {
        let context: CGContextRef = NSGraphicsContext.currentContext()!.CGContext
        CGContextSetFillColorWithColor(context, NSColor.blackColor().CGColor);
        CGContextSetAlpha(context, 1);
        CGContextFillRect(context, dirtyRect);
        append(" This is a test string")
        
        let range: NSRange = layoutmanager.glyphRangeForTextContainer(textContainer!)
        let point = CGPoint(x: 0, y: 0)
        layoutmanager.drawGlyphsForGlyphRange(range, atPoint: point)
        
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        textContainer = NSTextContainer(containerSize: NSSize(width: frame.size.width, height: frame.size.height))
        layoutmanager.addTextContainer(textContainer!)
        textStorage.addLayoutManager(layoutmanager)
        animationTimeInterval = 2
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        animationTimeInterval = 2
    
    }
    
    override func startAnimation() {
        super.startAnimation()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func animateOneFrame() {
        needsDisplay = true
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }
    
    override func configureSheet() -> NSWindow? {
        return nil
    }
    
    
    func append(string: NSString) {
        self.text = ((self.text)! as String) + (string as String)
        let attributedText = NSMutableAttributedString(string: text! as String)
        
         attributedText.addAttribute(NSForegroundColorAttributeName , value:NSColor.whiteColor(),range: NSMakeRange(0, text!.length))
        
        textStorage.setAttributedString(attributedText)
    }
    
}
