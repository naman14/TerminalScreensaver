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
    
    private var terminalColor: NSColor?
    private var terminalText: NSTextView?
    
    static var colorChangeNotification = "Configuration.colorChangeNotification"
    static var textChangeNotification = "Configuration.textChangeNotification"
    
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
        super.init(frame: frame, isPreview: isPreview)
        initialise()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialise()
    
    }
    
    private func initialise() {
         terminalColor = terminalColorPreference
         terminalText = terminalTextPreference
        
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
        }
        return configSheet
    }
    
    
    func append(string: NSString) {
        self.text = ((self.text)! as String) + (string as String)
        let attributedText = NSMutableAttributedString(string: text! as String)
        
         attributedText.addAttribute(NSForegroundColorAttributeName , value:NSColor.whiteColor(),range: NSMakeRange(0, text!.length))
        
        textStorage.setAttributedString(attributedText)
    }

    
    var terminalColorPreference: NSColor? {
        get {
            let color = defaults?.objectForKey("terminalColor") as? NSColor
            return color
        }
        
        set {
            if let color = newValue {
                defaults?.setObject(color, forKey: "terminalColor")
            } else {
                defaults?.removeObjectForKey("terminalColor")
            }
            defaults?.synchronize()
            
           //TODO update the defaults
        }
    }
    
    var terminalTextPreference: NSTextView? {
        get {
            let text = defaults?.objectForKey("terminalText") as? NSTextView
            return text
        }
        
        set {
            defaults?.setObject(newValue, forKey: "terminalText")
            defaults?.synchronize()
            
            //TODO update the defaults
        }
    }
    
    private let defaults: ScreenSaverDefaults? = {
        let bundleIdentifier = NSBundle(forClass: TerminalScreensaverView.self).bundleIdentifier
        return bundleIdentifier.flatMap { ScreenSaverDefaults(forModuleWithName: $0) }
    }()

    
}
