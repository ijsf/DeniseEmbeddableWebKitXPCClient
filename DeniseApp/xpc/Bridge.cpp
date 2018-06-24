//
//  Bridge.cpp
//  DeniseApp
//
//  Created by ijsf on 6/24/18.
//  Copyright © 2018-2020 C.E. Etheredge. All rights reserved.
//

#include "XPCClient.h"

extern "C" {

    XPCClient* xpcclient_create() {
        return new XPCClient();
    }

    void xpcclient_destroy(XPCClient* xpcclient) {
        delete xpcclient;
    }

    void xpcclient_connect(XPCClient* xpcclient) {
        xpcclient->connect();
    }
    
    void xpcclient_initialize(XPCClient* xpcclient, const unsigned int width, const unsigned int height) {
        xpcclient->initialize(width, height);
    }
    
    void xpcclient_loadURL(XPCClient* xpcclient, const char* url) {
        xpcclient->loadURL(std::string(url));
    }
    
    void xpcclient_setSize(XPCClient* xpcclient, const unsigned int width, const unsigned int height) {
        xpcclient->setSize(width, height);
    }
    
    void xpcclient_mouseMove(XPCClient* xpcclient, const unsigned int x, const unsigned int y, const unsigned int mods) {
        xpcclient->mouseMove(x, y, mods);
    }
    
    void xpcclient_mouseUp(XPCClient* xpcclient, const unsigned int x, const unsigned int y, const unsigned int mods) {
        xpcclient->mouseUp(x, y, mods);
    }
    
    void xpcclient_mouseDown(XPCClient* xpcclient, const unsigned int x, const unsigned int y, const unsigned int mods) {
        xpcclient->mouseDown(x, y, mods);
    }
    
    void xpcclient_keyPress(XPCClient* xpcclient, const unsigned int keys, const unsigned int mods) {
        xpcclient->keyPress(keys, mods);
    }
    
    typedef void(*CallbackFrame)(const void*, const unsigned long);
    void xpcclient_set_callback_frame(XPCClient* xpcclient, CallbackFrame cb) {
        xpcclient->setCallbackFrame(cb);
    }
}

