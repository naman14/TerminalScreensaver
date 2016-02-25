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
    
    private var textLabel: NSTextView?
    
    private var list: [NSString] = []
    private var readPosition: Int = 0
    
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
        
        let backgroundColor: NSColor = terminalColor!
        backgroundColor.setFill()
        NSBezierPath.fillRect(bounds)
        
        if(readPosition < list.count) {
            append(list[readPosition])
            append("\n")
            readPosition+=1
        }
        
    }
    
    override init?(frame: NSRect, isPreview: Bool) {
        let identifier = NSBundle(forClass: TerminalScreensaverView.self).bundleIdentifier
        defaults = ScreenSaverDefaults(forModuleWithName: identifier!)!
        
        super.init(frame: frame, isPreview: isPreview)
        initialise()
        readLog()
    }
    
    required init?(coder: NSCoder) {
        let identifier = NSBundle(forClass: TerminalScreensaverView.self).bundleIdentifier
        defaults = ScreenSaverDefaults(forModuleWithName: identifier!)!
        
        super.init(coder: coder)
        initialise()
        readLog()
        
    }
    
    private func initialise() {
        
        terminalColor = terminalColorPreference
        terminalTextColor = terminalTextColorPreference
        terminalText = terminalTextPreference
        isDelayRandom = delayRandomPreference
        lineDelay = lineDelayPreference
        
        textLabel = NSTextView(frame: bounds)
        textLabel!.frame = self.bounds
        textLabel!.translatesAutoresizingMaskIntoConstraints = false
        textLabel!.editable = false
        textLabel!.drawsBackground = false
        textLabel!.selectable = false
        addSubview(textLabel!)
        
        animationTimeInterval = 1/5
        
//        if((isDelayRandom) != nil) {
//            animationTimeInterval = 1/5
//        } else {
//            animationTimeInterval = 1/5
//        }
        
    }
    
    
    private func readLog() {
        let bundle = NSBundle(forClass: TerminalScreensaverView.self)
        let path = bundle.pathForResource("terminaltext", ofType: "txt")
        if let aStreamReader = StreamReader(path: path!) {
            defer {
                aStreamReader.close()
            }
            while let line = aStreamReader.nextLine() {
                list.append(line)
            }
        }
        
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
        let attributedString = NSMutableAttributedString(string: string as String)
        attributedString.addAttribute(NSForegroundColorAttributeName , value:terminalTextColor!,range: NSMakeRange(0, string.length))
        textLabel?.textStorage?.appendAttributedString(attributedString)
        textLabel?.scrollRangeToVisible(NSMakeRange((textLabel?.string!.characters.count)!, 0))
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
    
    
    class StreamReader  {
        
        let encoding : UInt
        let chunkSize : Int
        
        var fileHandle : NSFileHandle!
        let buffer : NSMutableData!
        let delimData : NSData!
        var atEof : Bool = false
        
        init?(path: String, delimiter: String = "\n", encoding : UInt = NSUTF8StringEncoding, chunkSize : Int = 4096) {
            self.chunkSize = chunkSize
            self.encoding = encoding
            
            if let fileHandle = NSFileHandle(forReadingAtPath: path),
                delimData = delimiter.dataUsingEncoding(encoding),
                buffer = NSMutableData(capacity: chunkSize)
            {
                self.fileHandle = fileHandle
                self.delimData = delimData
                self.buffer = buffer
            } else {
                self.fileHandle = nil
                self.delimData = nil
                self.buffer = nil
                return nil
            }
        }
        
        deinit {
            self.close()
        }
        
        /// Return next line, or nil on EOF.
        func nextLine() -> String? {
            precondition(fileHandle != nil, "Attempt to read from closed file")
            
            if atEof {
                return nil
            }
            
            // Read data chunks from file until a line delimiter is found:
            var range = buffer.rangeOfData(delimData, options: [], range: NSMakeRange(0, buffer.length))
            while range.location == NSNotFound {
                let tmpData = fileHandle.readDataOfLength(chunkSize)
                if tmpData.length == 0 {
                    // EOF or read error.
                    atEof = true
                    if buffer.length > 0 {
                        // Buffer contains last line in file (not terminated by delimiter).
                        let line = NSString(data: buffer, encoding: encoding)
                        
                        buffer.length = 0
                        return line as String?
                    }
                    // No more lines.
                    return nil
                }
                buffer.appendData(tmpData)
                range = buffer.rangeOfData(delimData, options: [], range: NSMakeRange(0, buffer.length))
            }
            
            // Convert complete line (excluding the delimiter) to a string:
            let line = NSString(data: buffer.subdataWithRange(NSMakeRange(0, range.location)),
                encoding: encoding)
            // Remove line (and the delimiter) from the buffer:
            buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
            
            return line as String?
        }
        
        /// Start reading from the beginning of file.
        func rewind() -> Void {
            fileHandle.seekToFileOffset(0)
            buffer.length = 0
            atEof = false
        }
        
        /// Close the underlying file. No reading must be done after calling this method.
        func close() -> Void {
            fileHandle?.closeFile()
            fileHandle = nil
        }
    }
    
    
}
