console.log('🟢 [BACKGROUND] Extension starting...');

function logToNative(message, type = 'info') {
    console.log(message);
    
    try {
        browser.runtime.sendNativeMessage('application.id', {
            action: 'log',
            message: message,
            type: type,
            timestamp: new Date().toISOString()
        }).catch(() => {
            if (browser.runtime.sendMessage) {
                browser.runtime.sendMessage({
                    action: 'logToNative',
                    message: message,
                    type: type
                }).catch(() => {});
            }
        });
    } catch (error) {

    }
}

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === 'log' || request.action === 'logToNative') {
        logToNative(request.message, request.type);
        sendResponse({ success: true });
    }
    
    return true;
});

logToNative('✅ Extension loaded', 'success');
