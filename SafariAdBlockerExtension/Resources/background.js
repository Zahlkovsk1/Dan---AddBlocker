// Background script

console.log('🟢 [BACKGROUND] Extension background script starting...');

// Log when extension is installed or updated
browser.runtime.onInstalled.addListener((details) => {
    console.log('🔧 [BACKGROUND] Extension installed/updated:', details.reason);
    if (details.reason === 'install') {
        console.log('✨ [BACKGROUND] First time installation');
    } else if (details.reason === 'update') {
        console.log('🔄 [BACKGROUND] Extension updated');
    }
});

// Log when extension starts up
browser.runtime.onStartup.addListener(() => {
    console.log('🚀 [BACKGROUND] Extension startup event fired');
});

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("📩 [BACKGROUND] Received request:", request);
    console.log("📍 [BACKGROUND] Sender:", sender);

    if (request.greeting === "hello") {
        console.log("👋 [BACKGROUND] Responding to hello message");
        return Promise.resolve({ farewell: "goodbye" });
    }
    
    // Log ad blocking events from content script
    if (request.action === 'adBlocked') {
        console.log(`🚫 [BACKGROUND] Ad blocked: ${request.type}, Total: ${request.count}`);
    }
    
    if (request.action === 'adSkipped') {
        console.log(`⏭️ [BACKGROUND] Ad skipped: Total: ${request.count}`);
    }
});

// error handling
self.addEventListener('error', (event) => {
    console.error('❌ [BACKGROUND] Error in background script:', event.error);
});

console.log('✅ [BACKGROUND] Background script fully loaded and ready');
