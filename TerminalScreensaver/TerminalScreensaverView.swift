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
    private var terminalTextColor: NSColor?
    private var terminalText: NSString?
    private var isDelayRandom: Bool?
    private var lineDelay: Int?
    
    @IBOutlet weak var configSheet: NSWindow! = nil
    @IBOutlet weak var textConfigSheet: NSWindow! = nil
    @IBOutlet weak var terminalColorWell: NSColorWell?
    @IBOutlet weak var terminalTextColorWell: NSColorWell?
    @IBOutlet weak var isDelayRandomButton: NSButton?
    @IBOutlet weak var lineDelaySlider: NSSlider?
    @IBOutlet weak var lineDelaySliderLabel: NSTextField?
    @IBOutlet var terminalTextView: NSTextView?
    

    
    @IBAction func applyClick(button: NSButton)
    {
       NSApp.endSheet(configSheet!)
    }
    
    @IBAction func backgroundColorClick(button: NSColorWell)
    {
        terminalColorPreference = terminalColorWell!.color
    }
    @IBAction func terminalTextColorClick(button: NSColorWell)
    {
        terminalTextColorPreference = terminalTextColorWell!.color
    }
    
    @IBAction func cancelClick(button: NSButton)
    {
        NSApp.endSheet(configSheet!)
    }
    @IBAction func cancelTextEditClick(button: NSButton)
    {
        NSApp.endSheet(textConfigSheet!)
    }
    @IBAction func delayRandomStateChange(button: NSButton)
    {
        if(button.state == NSOnState) {
           delayRandomPreference = true
        }
         else {
            delayRandomPreference = false
        }
    }
    @IBAction func lineDelaySliderChange(slider: NSSlider)
    {
       lineDelayPreference = slider.integerValue
       lineDelaySliderLabel?.stringValue = "\(slider.integerValue) seconds"
    }
    
    @IBAction func enterTextClick(button: NSButton)
    {
         if textConfigSheet == nil {
        let ourBundle = NSBundle(forClass: self.dynamicType)
        ourBundle.loadNibNamed("CustomTextWindow", owner: self, topLevelObjects: &nibArray)
         terminalTextView?.string = terminalTextPreference as String
            terminalTextView?.editable = true
            terminalTextView?.selectable
        }
    }
    
    @IBAction func saveTextClick(button: NSButton)
    {
        terminalTextPreference = (terminalTextView?.string)!
    }
    
    override func drawRect(dirtyRect: NSRect) {
        let context: CGContextRef = NSGraphicsContext.currentContext()!.CGContext
        CGContextSetFillColorWithColor(context, terminalColor?.CGColor);
        CGContextSetAlpha(context, 1);
        CGContextFillRect(context, dirtyRect);
        append(terminalText!)
        
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
        terminalTextColor = terminalTextColorPreference
        terminalText = terminalTextPreference
        isDelayRandom = delayRandomPreference
        lineDelay = lineDelayPreference
        
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
            terminalTextColorWell!.color = terminalTextColorPreference
            lineDelaySlider?.integerValue = lineDelayPreference
            lineDelaySliderLabel?.stringValue = "\(lineDelay!) seconds"
            if(delayRandomPreference){
                isDelayRandomButton?.state = NSOnState
            } else {
                isDelayRandomButton?.state = NSOffState
            }
        }
        return configSheet
    }
    
    
    func append(string: NSString) {
        self.text = ((self.text)! as String) + (string as String)
        let attributedText = NSMutableAttributedString(string: text! as String)
        
         attributedText.addAttribute(NSForegroundColorAttributeName , value:terminalTextColor!,range: NSMakeRange(0, text!.length))
        
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
    
    var terminalTextColorPreference: NSColor {
        set(newColor) {
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(newColor), forKey: "terminalTextColor")
            defaults.synchronize()
        }
        get {
            if let terminalColorData = defaults.objectForKey("terminalTextColor") as? NSData {
                return (NSKeyedUnarchiver.unarchiveObjectWithData(terminalColorData) as? NSColor)!
            }
            else {
                return NSColor.whiteColor()
            }
        }
    }
    
    var terminalTextPreference: NSString {
        set(newValue) {
            defaults.setObject(newValue, forKey: "terminalText")
            defaults.synchronize()
        }
        get {
            if let terminaltextData = defaults.objectForKey("terminalText") as? NSString {
                return terminaltextData
            }
            else {
                return NSString(string: "This is a lol string")
            }
        }
    }
    
    var delayRandomPreference: Bool {
        set(newValue) {
            defaults.setBool(newValue, forKey: "isDelayRandom")
            defaults.synchronize()
        }
        get {
            if let bool = defaults.boolForKey("isDelayRandom") as Bool? {
                return bool
            }
            else {
                return false
            }
        }
    }
    
    var lineDelayPreference: Int {
        set(newValue) {
            defaults.setInteger(newValue, forKey: "lineDelayInt")
            defaults.synchronize()
        }
        get {
            if let integer = defaults.integerForKey("lineDelayInt") as Int? {
                return integer
            }
            else {
                return 2
            }
        }
    }

    
}
