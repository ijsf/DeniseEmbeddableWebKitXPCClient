//
//  ViewController.swift
//  DeniseApp
//
//  Created by ijsf on 6/24/18.
//  Copyright © 2018-2020 C.E. Etheredge. All rights reserved.
//

import Cocoa

// Global ViewController hack
var gViewController: ViewController? = nil

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create XPC client and connect
        let xpcClient = xpcclient_create();
        xpcclient_connect(xpcClient);

        // Initialize XPC
        gViewController = self
        xpcclient_initialize(xpcClient, UInt32(imageView.frame.size.width), UInt32(imageView.frame.size.height))
        xpcclient_set_callback_frame(xpcClient, {
            (ptr, size) in
            DispatchQueue.main.async {
                print("frame")
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
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

