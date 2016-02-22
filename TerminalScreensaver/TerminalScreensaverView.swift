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
    
    var text: NSString?
    

    override func drawRect(dirtyRect: NSRect) {
        
        if let text = text {
        let point = CGPoint(x: (frame.size.width) / 2, y: (frame.size.height) / 2)
        text.drawAtPoint(point, withAttributes: nil)
            
        }
        
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        loadText()
        
    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadText()
        
    
    }
    
    override func startAnimation() {
        super.startAnimation()
    }
    
    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func animateOneFrame() {
        
    }
    
    override func hasConfigureSheet() -> Bool {
        return false
    }
    
    override func configureSheet() -> NSWindow? {
        return nil
    }
    
    
    func loadText() {
       text = "This is a test string"
        self.needsDisplay = true;
    }
    
}
