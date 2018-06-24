//
//  ViewController.swift
//  DeniseApp
//
//  Created by ijsf on 6/24/18.
//  Copyright © 2018-2020 C.E. Etheredge. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

// Global ViewController hack
var gViewController: ViewController? = nil

///
enum ModifierKeys:UInt32 {
    case MODIFIER_NONE = 0
    case MODIFIER_SHIFT = 1
    case MODIFIER_CTRL = 2
    case MODIFIER_ALT = 4
    case MODIFIER_COMMAND = 8
    case MODIFIER_LEFT_MOUSE = 16
    case MODIFIER_RIGHT_MOUSE = 32
    case MODIFIER_MIDDLE_MOUSE = 64
};

enum Key:UInt32 {
    case KEY_SPACE
    case KEY_ESCAPE
    case KEY_RETURN
    case KEY_TAB
    case KEY_DELETE
    case KEY_BACKSPACE
    case KEY_INSERT
    case KEY_UP
    case KEY_DOWN
    case KEY_LEFT
    case KEY_RIGHT
    case KEY_PAGE_UP
    case KEY_PAGE_DOWN
    case KEY_HOME
    case KEY_END
    
    case KEY_F1
    case KEY_F2
    case KEY_F3
    case KEY_F4
    case KEY_F5
    case KEY_F6
    case KEY_F7
    case KEY_F8
    case KEY_F9
    case KEY_F10
    case KEY_F11
    case KEY_F12
    
    case KEY_NUMPAD_0
    case KEY_NUMPAD_1
    case KEY_NUMPAD_2
    case KEY_NUMPAD_3
    case KEY_NUMPAD_4
    case KEY_NUMPAD_5
    case KEY_NUMPAD_6
    case KEY_NUMPAD_7
    case KEY_NUMPAD_8
    case KEY_NUMPAD_9
    
    case KEY_NUMPAD_ADD
    case KEY_NUMPAD_SUBTRACT
    case KEY_NUMPAD_MULTIPLY
    case KEY_NUMPAD_DIVIDE
    case KEY_NUMPAD_SEPARATOR   // not mappable
    case KEY_NUMPAD_DECIMAL
    case KEY_NUMPAD_EQUAL
    case KEY_NUMPAD_DELETE
};
///

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    var xpcClient: OpaquePointer = xpcclient_create()
    var isInitialized: Bool = false
    
    func convertModifier(theEvent: NSEvent) -> UInt32 {
        var mods = UInt32(0)
        if (theEvent.modifierFlags.contains(.shift)) {
            mods |= ModifierKeys.MODIFIER_SHIFT.rawValue
        }
        if (theEvent.modifierFlags.contains(.control)) {
            mods |= ModifierKeys.MODIFIER_CTRL.rawValue
        }
        if (theEvent.modifierFlags.contains(.option)) {
            mods |= ModifierKeys.MODIFIER_ALT.rawValue
        }
        if (theEvent.modifierFlags.contains(.command)) {
            mods |= ModifierKeys.MODIFIER_COMMAND.rawValue
        }
        return mods
    }
    
    override func keyDown(with theEvent: NSEvent) {
        if (isInitialized && theEvent.window != nil) {
            let mods = convertModifier(theEvent: theEvent)
            var keys = UInt32(0)
            switch (Int(theEvent.keyCode)) {
            case kVK_Space:
                keys = Key.KEY_SPACE.rawValue
            case kVK_Escape:
                keys = Key.KEY_ESCAPE.rawValue
            case kVK_Return:
                keys = Key.KEY_RETURN.rawValue
            case kVK_Tab:
                keys = Key.KEY_TAB.rawValue
            case kVK_ForwardDelete:
                keys = Key.KEY_DELETE.rawValue
            case kVK_Delete:
                keys = Key.KEY_BACKSPACE.rawValue
            case kVK_Help:
                keys = Key.KEY_INSERT.rawValue
            case kVK_UpArrow:
                keys = Key.KEY_UP.rawValue
            case kVK_DownArrow:
                keys = Key.KEY_DOWN.rawValue
            case kVK_LeftArrow:
                keys = Key.KEY_LEFT.rawValue
            case kVK_RightArrow:
                keys = Key.KEY_RIGHT.rawValue
            case kVK_PageUp:
                keys = Key.KEY_PAGE_UP.rawValue
            case kVK_PageDown:
                keys = Key.KEY_PAGE_DOWN.rawValue
            case kVK_Home:
                keys = Key.KEY_HOME.rawValue
            case kVK_End:
                keys = Key.KEY_END.rawValue

            case NSF1FunctionKey:
                keys = Key.KEY_F1.rawValue
            case NSF2FunctionKey:
                keys = Key.KEY_F2.rawValue
            case NSF3FunctionKey:
                keys = Key.KEY_F3.rawValue
            case NSF4FunctionKey:
                keys = Key.KEY_F4.rawValue
            case NSF5FunctionKey:
                keys = Key.KEY_F5.rawValue
            case NSF6FunctionKey:
                keys = Key.KEY_F6.rawValue
            case NSF7FunctionKey:
                keys = Key.KEY_F7.rawValue
            case NSF8FunctionKey:
                keys = Key.KEY_F8.rawValue
            case NSF9FunctionKey:
                keys = Key.KEY_F9.rawValue
            case NSF10FunctionKey:
                keys = Key.KEY_F10.rawValue
            case NSF11FunctionKey:
                keys = Key.KEY_F11.rawValue
            case NSF12FunctionKey:
                keys = Key.KEY_F12.rawValue
                
            case kVK_ANSI_Keypad0:
                keys = Key.KEY_NUMPAD_0.rawValue
            case kVK_ANSI_Keypad1:
                keys = Key.KEY_NUMPAD_1.rawValue
            case kVK_ANSI_Keypad2:
                keys = Key.KEY_NUMPAD_2.rawValue
            case kVK_ANSI_Keypad3:
                keys = Key.KEY_NUMPAD_3.rawValue
            case kVK_ANSI_Keypad4:
                keys = Key.KEY_NUMPAD_4.rawValue
            case kVK_ANSI_Keypad5:
                keys = Key.KEY_NUMPAD_5.rawValue
            case kVK_ANSI_Keypad6:
                keys = Key.KEY_NUMPAD_6.rawValue
            case kVK_ANSI_Keypad7:
                keys = Key.KEY_NUMPAD_7.rawValue
            case kVK_ANSI_Keypad8:
                keys = Key.KEY_NUMPAD_8.rawValue
            case kVK_ANSI_Keypad9:
                keys = Key.KEY_NUMPAD_9.rawValue

            case kVK_ANSI_KeypadPlus:
                keys = Key.KEY_NUMPAD_ADD.rawValue
            case kVK_ANSI_KeypadMinus:
                keys = Key.KEY_NUMPAD_SUBTRACT.rawValue
            case kVK_ANSI_KeypadMultiply:
                keys = Key.KEY_NUMPAD_MULTIPLY.rawValue
            case kVK_ANSI_KeypadDivide:
                keys = Key.KEY_NUMPAD_DIVIDE.rawValue
            case kVK_ANSI_KeypadDecimal:
                keys = Key.KEY_NUMPAD_DECIMAL.rawValue
            case kVK_ANSI_KeypadEquals:
                keys = Key.KEY_NUMPAD_EQUAL.rawValue
            case kVK_ANSI_KeypadClear:
                keys = Key.KEY_NUMPAD_DELETE.rawValue
            default:
                keys = UInt32(theEvent.charactersIgnoringModifiers!.utf16.first!)
            }
            print(mods, keys)
            xpcclient_keyPress(xpcClient, keys, mods)
        }
    }
    
    override func mouseUp(with theEvent: NSEvent) {
        if (isInitialized && theEvent.window != nil) {
            if (theEvent.locationInWindow.x >= 0 && theEvent.locationInWindow.y >= 0 && theEvent.locationInWindow.x < self.view.frame.width && theEvent.locationInWindow.y < self.view.frame.height) {
                let mods = convertModifier(theEvent: theEvent) | ModifierKeys.MODIFIER_LEFT_MOUSE.rawValue
                let x = UInt32(theEvent.locationInWindow.x)
                let y = UInt32(self.view.frame.height - theEvent.locationInWindow.y)
                print("mouseUp", x, y, mods)
                xpcclient_mouseUp(xpcClient, x, y, mods)
            }
        }
    }
    override func rightMouseUp(with theEvent: NSEvent) {
        if (isInitialized && theEvent.window != nil) {
            let mods = convertModifier(theEvent: theEvent) | ModifierKeys.MODIFIER_RIGHT_MOUSE.rawValue
            let x = UInt32(theEvent.locationInWindow.x)
            let y = UInt32(self.view.frame.height - theEvent.locationInWindow.y)
            print("mouseUp", x, y, mods)
            xpcclient_mouseUp(xpcClient, x, y, mods)
        }
    }
    override func mouseDown(with theEvent: NSEvent) {
        if (isInitialized && theEvent.window != nil) {
            if (theEvent.locationInWindow.x >= 0 && theEvent.locationInWindow.y >= 0 && theEvent.locationInWindow.x < self.view.frame.width && theEvent.locationInWindow.y < self.view.frame.height) {
                let mods = convertModifier(theEvent: theEvent) | ModifierKeys.MODIFIER_LEFT_MOUSE.rawValue
                let x = UInt32(theEvent.locationInWindow.x)
                let y = UInt32(self.view.frame.height - theEvent.locationInWindow.y)
                print("mouseDown", x, y, mods)
                xpcclient_mouseDown(xpcClient, x, y, mods)
            }
        }
    }
    override func rightMouseDown(with theEvent: NSEvent) {
        if (isInitialized && theEvent.window != nil) {
            if (theEvent.locationInWindow.x >= 0 && theEvent.locationInWindow.y >= 0 && theEvent.locationInWindow.x < self.view.frame.width && theEvent.locationInWindow.y < self.view.frame.height) {
                let mods = convertModifier(theEvent: theEvent) | ModifierKeys.MODIFIER_RIGHT_MOUSE.rawValue
                let x = UInt32(theEvent.locationInWindow.x)
                let y = UInt32(self.view.frame.height - theEvent.locationInWindow.y)
                print("mouseDown", x, y, mods)
                xpcclient_mouseDown(xpcClient, x, y, mods)
            }
        }
    }

    override func mouseMoved(with theEvent: NSEvent) {
        if (isInitialized && theEvent.window != nil) {
            if (theEvent.locationInWindow.x >= 0 && theEvent.locationInWindow.y >= 0 && theEvent.locationInWindow.x < self.view.frame.width && theEvent.locationInWindow.y < self.view.frame.height) {
                let x = UInt32(theEvent.locationInWindow.x)
                let y = UInt32(self.view.frame.height - theEvent.locationInWindow.y)
                print("mouseMove", x, y)
                xpcclient_mouseMove(xpcClient, x, y, 0)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ACHTUNG: view may disappear?
        
        // Create XPC client and connect
        xpcclient_connect(xpcClient);

        // Initialize XPC
        gViewController = self
        xpcclient_initialize(xpcClient, UInt32(imageView.frame.size.width), UInt32(imageView.frame.size.height))
        xpcclient_set_callback_frame(xpcClient, {
            (ptr, size) in
            DispatchQueue.main.async {
                let imageWidth = gViewController!.imageView.frame.size.width
                let imageHeight = gViewController!.imageView.frame.size.height
                let buffer = Array(UnsafeBufferPointer(start: ptr!.assumingMemoryBound(to: UInt8.self), count: Int(size)))
                let providerRef = CGDataProvider(
                    data: NSData(bytes: buffer, length: Int(size))
                )
                let cgImage = CGImage(
                    width: Int(imageWidth),
                    height: Int(imageHeight),
                    bitsPerComponent: 8,
                    bitsPerPixel: 32,
                    bytesPerRow: Int(imageWidth) * 4,
                    space: CGColorSpaceCreateDeviceRGB(),
                    bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue),
                    provider: providerRef!,
                    decode: nil,
                    shouldInterpolate: true,
                    intent: .defaultIntent
                )
                gViewController!.imageView.image = NSImage(
                    cgImage: cgImage!,
                    size: NSSize(width: imageWidth, height: imageHeight)
                )
            }
        })
        xpcclient_loadURL(xpcClient, "https://denise:neu2018@daw.denise.io/")
        isInitialized = true
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

