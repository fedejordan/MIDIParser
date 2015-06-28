//
//  AppDelegate.swift
//  MIDIParser
//
//  Created by Federico Jordán on 27/6/15.
//  Copyright (c) 2015 Federico Jordán. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var mainViewController: MainViewController!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
         mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        window.contentView.addSubview(mainViewController!.view)
        mainViewController!.view.frame = (window.contentView as! NSView).bounds
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

