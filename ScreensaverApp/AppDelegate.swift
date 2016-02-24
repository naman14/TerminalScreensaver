//
//  AppDelegate.swift
//  ScreensaverApp
//
//  Created by Naman on 22/02/16.
//  Copyright © 2016 naman14. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow?
    
    lazy var screenSaverView = TerminalScreensaverView(frame: NSZeroRect, isPreview: false)


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        if let screenSaverView = screenSaverView {
            screenSaverView.frame = window!.contentView!.bounds;
            window!.contentView!.addSubview(screenSaverView);
            NSTimer.scheduledTimerWithTimeInterval(screenSaverView.animationTimeInterval, target: screenSaverView, selector: "animateOneFrame", userInfo: nil, repeats: true)

        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }


}

