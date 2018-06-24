//
//  MyView.swift
//  DeniseApp
//
//  Created by ijsf on 6/24/18.
//  Copyright © 2018-2020 C.E. Etheredge. All rights reserved.
//

import Foundation
import Cocoa

class CustomView: NSView {
    // Allow view to receive keypress (remove the purr sound)
    override var acceptsFirstResponder : Bool {
        return true
    }
    
    override func viewDidMoveToWindow() {
        window?.acceptsMouseMovedEvents = true
    }
}
