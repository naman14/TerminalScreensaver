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
    private var nibArray: NSArray? = nil
    
    var defaults: NSUserDefaults
    
    private var terminalColor: NSColor?
    
    @IBOutlet weak var configSheet: NSWindow! = nil
    @IBOutlet weak var textConfigSheet: NSWindow! = nil
    @IBOutlet weak var terminalColorWell: NSColorWell?
    

    @IBAction func applyClick(button: NSButton)
    {
       
    }
    
    @IBAction func backgroundColorClick(button: NSColorWell)
    {
        terminalColorPreference = terminalColorWell!.color
    }
    
    @IBAction func cancelClick(button: NSButton)
    {
        NSApp.endSheet(configSheet!)
    }
    @IBAction func cancelTextEditClick(button: NSButton)
    {
        NSApp.endSheet(textConfigSheet!)
    }
    
    @IBAction func enterTextClick(button: NSButton)
    {
         if textConfigSheet == nil {
        let ourBundle = NSBundle(forClass: self.dynamicType)
        ourBundle.loadNibNamed("CustomTextWindow", owner: self, topLevelObjects: &nibArray)
        }
    }
    
    @IBAction func saveTextClick(button: NSButton)
    {
        
    }
    
    
    override func drawRect(dirtyRect: NSRect) {
        let context: CGContextRef = NSGraphicsContext.currentContext()!.CGContext
        CGContextSetFillColorWithColor(context, terminalColor?.CGColor);
        CGContextSetAlpha(context, 1);
        CGContextFillRect(context, dirtyRect);
        append(" This is a test string")
        
        let range: NSRange = layoutmanager.glyphRangeForTextContainer(textContainer!)
        let point = CGPoint(x: 0, y: frame.size.height/2)
        layoutmanager.drawGlyphsForGlyphRange(range, atPoint: point)
        
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        let identifier = NSBundle(forClass: TerminalScreensaverView.self).bundleIdentifier
        defaults = ScreenSaverDefaults(forModuleWithName: identifier!)!
        super.init(frame: frame, isPreview: isPreview)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        let identifier = NSBundle(forClass: TerminalScreensaverView.self).bundleIdentifier
        defaults = ScreenSaverDefaults(forModuleWithName: identifier!)!
        super.init(coder: coder)
        initialise()
    
    }
    
    private func initialise() {
        
        terminalColor = terminalColorPreference
        
        textContainer = NSTextContainer(containerSize: NSSize(width: frame.size.width, height: frame.size.height))
        layoutmanager.addTextContainer(textContainer!)
        textStorage.addLayoutManager(layoutmanager)
        animationTimeInterval = 1/5

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
        return true
    }
    
    override func configureSheet() -> NSWindow? {
        if configSheet == nil {
            let ourBundle = NSBundle(forClass: self.dynamicType)
            ourBundle.loadNibNamed("PreferenceWindow", owner: self, topLevelObjects: &nibArray)
            terminalColorWell!.color = terminalColorPreference
        }
        return configSheet
    }
    
    
    func append(string: NSString) {
        self.text = ((self.text)! as String) + (string as String)
        let attributedText = NSMutableAttributedString(string: text! as String)
        
         attributedText.addAttribute(NSForegroundColorAttributeName , value:NSColor.whiteColor(),range: NSMakeRange(0, text!.length))
        
        textStorage.setAttributedString(attributedText)
    }

    

    var terminalColorPreference: NSColor {
        set(newColor) {
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(newColor), forKey: "terminalColor")
            defaults.synchronize()
        }
        get {
            if let terminalColorData = defaults.objectForKey("terminalColor") as? NSData {
                return (NSKeyedUnarchiver.unarchiveObjectWithData(terminalColorData) as? NSColor)!
            }
            else {
                return NSColor.blackColor()
            }
        }
    }
    
}
