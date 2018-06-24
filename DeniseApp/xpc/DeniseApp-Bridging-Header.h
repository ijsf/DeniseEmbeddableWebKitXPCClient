//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

typedef struct XPCClient XPCClient;

XPCClient* xpcclient_create();
void xpcclient_destroy(XPCClient* xpcclient);

void xpcclient_connect(XPCClient* xpcclient);
void xpcclient_initialize(XPCClient* xpcclient, const unsigned int width, const unsigned int height);
void xpcclient_loadURL(XPCClient* xpcclient, const char* url);
void xpcclient_setSize(XPCClient* xpcclient, const unsigned int width, const unsigned int height);

void xpcclient_mouseMove(XPCClient* xpcclient, const unsigned int x, const unsigned int y, const unsigned int mods);
void xpcclient_mouseUp(XPCClient* xpcclient, const unsigned int x, const unsigned int y, const unsigned int mods);
void xpcclient_mouseDown(XPCClient* xpcclient, const unsigned int x, const unsigned int y, const unsigned int mods);
void xpcclient_keyPress(XPCClient* xpcclient, const unsigned int keys, const unsigned int mods);

typedef void(*CallbackFrame)(const void*, const unsigned long);
void xpcclient_set_callback_frame(XPCClient*, CallbackFrame cb);
