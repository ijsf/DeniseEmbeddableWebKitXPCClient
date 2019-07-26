//
//  AppDelegate.swift
//  DeniseApp
//
//  Created by ijsf on 6/24/18.
//  Copyright © 2018-2020 C.E. Etheredge. All rights reserved.
//

import Cocoa

// C/C++ callbacks
@_cdecl("CB_notificationSet")
func CB_notificationSet() {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    appDelegate.setIcon(iconName: "statusActiveIcon");
}
@_cdecl("CB_notificationReset")
func CB_notificationReset() {
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    appDelegate.setIcon(iconName: "statusIcon");
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    // Sets the taskbar icon
    func setIcon(iconName: String) {
        let icon = NSImage(named: NSImage.Name(iconName))
        //icon?.isTemplate = true // dark mode

        // Set up status item button
        if let button = statusItem.button {
            button.image = icon;
            button.action = #selector(AppDelegate.togglePopover(_:))
            //popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Set up status item icon
        setIcon(iconName: "statusIcon");

        // Instantiate view controller
        let mainViewController = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ViewControllerId")) as! ViewController
        
        // Set popover's view controller
        popover.contentViewController = mainViewController
        
        // Set up event monitor
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
            if let popover = self?.popover {
                if popover.isShown {
                    self?.closePopover(event)
                }
            }
        }
        eventMonitor?.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}

