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
    
    var text: String? = "This is a test string"
    

    override func drawRect(dirtyRect: NSRect) {
        let context: CGContextRef = NSGraphicsContext.currentContext()!.CGContext
        CGContextSetFillColorWithColor(context, NSColor.blackColor().CGColor);
        CGContextSetAlpha(context, 1);
        CGContextFillRect(context, dirtyRect);
        append("This is a test string")
        if let text = text {
        let point = CGPoint(x: 0, y: frame.size.height-20)
            
            let textFontAttributes = [
                NSForegroundColorAttributeName: NSColor.whiteColor()
            ]
            
        text.drawAtPoint(point, withAttributes: textFontAttributes)
            
        }
        
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
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
    
    
    func append(string: String) {
        self.text = (self.text)! + string
    }
    
}
