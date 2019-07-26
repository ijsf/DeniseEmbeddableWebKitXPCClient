//
//  Copyright © 2018-2020 C.E. Etheredge. All rights reserved.
//

#ifndef XPCClient_hpp
#define XPCClient_hpp

#include <functional>
#include <string>
#include <xpc/xpc.h>

#include "interface/Constants.h"

class XPCClient {
public:
    const char* MACH_SERVICE_NAME = "com.denise.daemon";
    const char* SHM_NAME = "denise";

    typedef std::function<void(const void*, const size_t)> CallbackPaint;
    typedef std::function<void(const bool)> CallbackIsLoading;
    typedef std::function<void(const Browser::LoadEvent, const std::string, const uint, const std::string)> CallbackLoadFailed;
    typedef std::function<void(const Denise::Wrapper::ProductType, const std::string, const std::string)> CallbackDeniseLoadProduct;
    typedef std::function<void(const bool)> CallbackDeniseSetOverlay;
    typedef std::function<void(const bool)> CallbackDeniseSetHeader;
    typedef std::function<void(void)> CallbackDeniseAppNotificationSet;
    typedef std::function<void(void)> CallbackDeniseAppNotificationReset;

    XPCClient() : m_frameData(nullptr), m_frameSize(0) {
    }
    
    virtual ~XPCClient() {
        // Close connection, so that no callbacks are fired
        xpc_connection_cancel(m_connMachService);
        
        // Close shared memory region
        shmClose();
    }
    
    void setCallbackFrame(CallbackPaint cb) {
        m_callbackFrame = cb;
    }
    void setCallbackIsLoading(CallbackIsLoading cb) {
        m_callbackIsLoading = cb;
    }
    void setCallbackLoadFailed(CallbackLoadFailed cb) {
        m_callbackLoadFailed = cb;
    }
    void setCallbackDeniseLoadProduct(CallbackDeniseLoadProduct cb) {
        m_callbackDeniseLoadProduct = cb;
    }
    void setCallbackDeniseSetOverlay(CallbackDeniseSetOverlay cb) {
        m_callbackDeniseSetOverlay = cb;
    }
    void setCallbackDeniseSetHeader(CallbackDeniseSetHeader cb) {
        m_callbackDeniseSetHeader = cb;
    }
    void setCallbackDeniseAppNotificationSet(CallbackDeniseAppNotificationSet cb) {
        m_callbackDeniseAppNotificationSet = cb;
    }
    void setCallbackDeniseAppNotificationReset(CallbackDeniseAppNotificationReset cb) {
        m_callbackDeniseAppNotificationReset = cb;
    }

    bool connect() {
        // Create mach service (client)
        m_connMachService = xpc_connection_create_mach_service(MACH_SERVICE_NAME, NULL, 0);
        if (m_connMachService != nullptr) {
            // ACHTUNG: callbacks may not be valid
            // General event/message handler
            xpc_connection_set_event_handler(m_connMachService, ^(xpc_object_t event) {
                if (xpc_get_type(event) == XPC_TYPE_DICTIONARY) {
                    // frame
                    if (xpc_dictionary_get_value(event, "frame")) {
                        if (m_callbackFrame) {
                            m_callbackFrame(m_frameData, m_frameSize);
                        }
                    }
                    // isLoading
                    if (xpc_dictionary_get_value(event, "isLoading")) {
                        if (m_callbackIsLoading) {
                            m_callbackIsLoading(xpc_dictionary_get_bool(event, "isLoading"));
                        }
                    }
                    // loadFailed
                    if (xpc_dictionary_get_value(event, "loadFailed")) {
                        xpc_object_t dict = xpc_dictionary_get_value(event, "loadFailed");
                        if (xpc_get_type(dict) == XPC_TYPE_DICTIONARY) {
                            Browser::LoadEvent loadEvent = (Browser::LoadEvent)xpc_dictionary_get_uint64(dict, "event");
                            std::string URI = xpc_dictionary_get_string(dict, "uri");
                            uint errorCode = (uint)xpc_dictionary_get_uint64(dict, "errorCode");
                            std::string errorMessage = xpc_dictionary_get_string(dict, "errorMessage");
                            if (m_callbackLoadFailed) {
                                m_callbackLoadFailed(loadEvent, URI, errorCode, errorMessage);
                            }
                        }
                    }
                    // deniseLoadProduct
                    if (xpc_dictionary_get_value(event, "deniseLoadProduct")) {
                        xpc_object_t dict = xpc_dictionary_get_value(event, "deniseLoadProduct");
                        if (xpc_get_type(dict) == XPC_TYPE_DICTIONARY) {
                            const Denise::Wrapper::ProductType productType = (Denise::Wrapper::ProductType)xpc_dictionary_get_uint64(dict, "productType");
                            std::string productId = xpc_dictionary_get_string(dict, "productId");
                            std::string productLoadData = xpc_dictionary_get_string(dict, "productLoadData");
                            if (m_callbackDeniseLoadProduct) {
                                m_callbackDeniseLoadProduct(productType, productId, productLoadData);
                            }
                        }
                    }
                    // deniseSetOverlay
                    if (xpc_dictionary_get_value(event, "deniseSetOverlay")) {
                        if (m_callbackDeniseSetOverlay) {
                            m_callbackDeniseSetOverlay(xpc_dictionary_get_bool(event, "deniseSetOverlay"));
                        }
                    }
                    // deniseSetHeader
                    if (xpc_dictionary_get_value(event, "deniseSetHeader")) {
                        if (m_callbackDeniseSetHeader) {
                            m_callbackDeniseSetHeader(xpc_dictionary_get_bool(event, "deniseSetHeader"));
                        }
                    }
                    // deniseAppNotificationSet
                    if (xpc_dictionary_get_value(event, "deniseAppNotificationSet")) {
                        if (m_callbackDeniseAppNotificationSet) {
                            m_callbackDeniseAppNotificationSet();
                        }
                    }
                    // deniseAppNotificationReset
                    if (xpc_dictionary_get_value(event, "deniseAppNotificationReset")) {
                        if (m_callbackDeniseAppNotificationReset) {
                            m_callbackDeniseAppNotificationReset();
                        }
                    }
                }
                else if (xpc_get_type(event) == XPC_TYPE_ERROR) {
                    printf("XPC error: %p\n", event);
                    printf("%s\n", xpc_copy_description(event));
                }
            });
            
            // Resume connection
            xpc_connection_resume(m_connMachService);
            
            return true;
        }
        return false;
    }
    
    /*** Browser ***/
    void initialize(const uint width, const uint height) {
        setSize(width, height);
    }
    
    void loadURL(const std::string& url) {
        if (m_connMachService) {
            // Communicate with XPCService
            xpc_object_t msg = xpc_dictionary_create(NULL, NULL, 0);
            {
                xpc_dictionary_set_string(msg, "loadURL", url.c_str());
            }
            xpc_object_t reply = xpc_connection_send_message_with_reply_sync(m_connMachService, msg);
        }
    }
    
    void setSize(const uint width, const uint height) {
        if (m_connMachService) {
            // ACHTUNG stride 4 (ARGB32)
            const uint stride = 4;
            const size_t frameSize = width * height * stride;

            // If frame data exists, take care of cleanup first
            if (m_frameData) {
                // First, unmap the shared memory through XPC
                {
                    xpc_object_t msg = xpc_dictionary_create(NULL, NULL, 0);
                    {
                        xpc_object_t frame = xpc_dictionary_create(NULL, NULL, 0);
                        {
                            // null
                        }
                        xpc_dictionary_set_value(msg, "frame", frame);
                    }
                    xpc_object_t reply = xpc_connection_send_message_with_reply_sync(m_connMachService, msg);
                }
                
                // Deallocate and unmap the shared memory locally
                deallocateSharedMemory(m_frameData, m_frameSize);
            }

            // Allocate new shared memory
            void* frameData = allocateSharedMemory(frameSize);
            if (frameData) {
                // Communicate with XPCService
                xpc_object_t msg = xpc_dictionary_create(NULL, NULL, 0);
                {
                    xpc_object_t frame = xpc_dictionary_create(NULL, NULL, 0);
                    {
                        xpc_dictionary_set_uint64(frame, "width", (uint64_t)width);
                        xpc_dictionary_set_uint64(frame, "height", (uint64_t)height);
                        xpc_dictionary_set_uint64(frame, "stride", (uint64_t)stride);
                        xpc_dictionary_set_value(frame, "shm", xpc_shmem_create(frameData, frameSize));
                    }
                    xpc_dictionary_set_value(msg, "frame", frame);
                }
                // Exchange shared memory region with service,
                // sync with reply so that the old m_frame will no longer be used
                xpc_object_t reply = xpc_connection_send_message_with_reply_sync(m_connMachService, msg);
            }
            m_frameData = frameData;
            m_frameSize = frameSize;
        }
    }
    
    void mouseMove(const uint x, const uint y, const uint mods) {
        mouseEvent("mouseMove", x, y, mods);
    }

    void mouseUp(const uint x, const uint y, const uint mods) {
        mouseEvent("mouseUp", x, y, mods);
    }

    void mouseDown(const uint x, const uint y, const uint mods) {
        mouseEvent("mouseDown", x, y, mods);
    }
    
    void keyPress(const uint keys, const uint mods) {
        // Communicate with XPCService
        xpc_object_t msg = xpc_dictionary_create(NULL, NULL, 0);
        {
            xpc_object_t dict = xpc_dictionary_create(NULL, NULL, 0);
            {
                xpc_dictionary_set_uint64(dict, "keys", (uint64_t)keys);
                xpc_dictionary_set_uint64(dict, "mods", (uint64_t)mods);
            }
            xpc_dictionary_set_value(msg, "keyPress", dict);
        }
        xpc_connection_send_message(m_connMachService, msg);
    }

private:
    void mouseEvent(const char* event, const uint x, const uint y, const uint mods) {
        // Communicate with XPCService
        xpc_object_t msg = xpc_dictionary_create(NULL, NULL, 0);
        {
            xpc_object_t dict = xpc_dictionary_create(NULL, NULL, 0);
            {
                xpc_dictionary_set_uint64(dict, "x", (uint64_t)x);
                xpc_dictionary_set_uint64(dict, "y", (uint64_t)y);
                xpc_dictionary_set_uint64(dict, "mods", (uint64_t)mods);
            }
            xpc_dictionary_set_value(msg, event, dict);
        }
        xpc_connection_send_message(m_connMachService, msg);
    }

    void* allocateSharedMemory(const size_t size) {
        if (shmOpen(size)) {
            // mmap region as shared memory
            void* data = mmap(nullptr, size, PROT_READ | PROT_WRITE, MAP_SHARED, m_fdShm, 0);
            
            // Clear contents
            memset(data, 0, size);
            
            // Return mmapped region
            return data;
        }
        return nullptr;
    }
    
    void deallocateSharedMemory(void* data, const size_t size) {
        munmap(data, size);
        shmClose();
    }
    
    bool shmOpen(const size_t size) {
        // Make sure no shm exists
        shmClose();
        
        // Open shm device
        m_fdShm = shm_open(SHM_NAME, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
        if (m_fdShm >= 0) {
            // Set shared memory size
            ftruncate(m_fdShm, size);
            return true;
        }
        return false;
    };
    
    bool shmClose() {
        shm_unlink(SHM_NAME);
        return true;
    };
    
private:
    xpc_connection_t m_connMachService;
    int m_fdShm;
    
    // Shared memory region for frame buffer
    void* m_frameData;
    size_t m_frameSize;
    
    // Callbacks
    CallbackPaint m_callbackFrame;
    CallbackIsLoading m_callbackIsLoading;
    CallbackLoadFailed m_callbackLoadFailed;
    CallbackDeniseLoadProduct m_callbackDeniseLoadProduct;
    CallbackDeniseSetOverlay m_callbackDeniseSetOverlay;
    CallbackDeniseSetHeader m_callbackDeniseSetHeader;
    CallbackDeniseAppNotificationSet m_callbackDeniseAppNotificationSet;
    CallbackDeniseAppNotificationReset m_callbackDeniseAppNotificationReset;
};

#endif /* XPCClient_hpp */
