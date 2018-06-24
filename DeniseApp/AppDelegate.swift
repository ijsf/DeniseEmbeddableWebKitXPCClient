//
//  AppDelegate.swift
//  DeniseApp
//
//  Created by ijsf on 6/24/18.
//  Copyright © 2018-2020 C.E. Etheredge. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    @IBOutlet weak var statusMenu: NSMenu!
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        // Set the text that appears in the menu bar
        let icon = NSImage(named: NSImage.Name("statusIcon"))
        icon?.isTemplate = true // dark mode
        statusItem.image = icon
        
        // Set the menu that should appear when the item is clicked
        statusItem.menu = statusMenu
        
        // Set if the item should change color when clicked
        statusItem.highlightMode = true
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

