// YouTube Mobile Ad Blocker

(function() {
    'use strict';
    
   
    function logToApp(message, type = 'info') {
        console.log(message);
        
        try {
            if (browser?.runtime?.sendMessage) {
                browser.runtime.sendMessage({
                    action: 'log',
                    message: message,
                    type: type,
                    timestamp: new Date().toISOString()
                }).catch(() => {});
            }
        } catch (error) {
           
        }
    }
    
    logToApp('🚀 AdBlocker Active', 'success');
    
    let adStats = {
        adsSkipped: 0,
        adsFastForwarded: 0,
        transitionSkips: 0
    };
    
    let lastAction = 0;
    let wasInAd = false;
    let consecutiveAdChecks = 0;
    let isProcessingMultipleAds = false;
    let ensurePlaybackInterval = null;
    let lastTransitionSkip = 0;
  
    try {
        const style = document.createElement('style');
        style.textContent = `
            ytd-display-ad-renderer,
            ytd-promoted-sparkles-web-renderer,
            ytd-banner-promo-renderer,
            .ytp-ad-image-overlay,
            .ytp-ad-text-overlay {
                display: none !important;
            }
        `;
        document.head.appendChild(style);
    } catch (error) {
        logToApp('Failed to inject ad blocker styles', 'error');
    }
    
    function realClick(element) {
        if (!element) return false;
        
        try {
            const touchStart = new TouchEvent('touchstart', {
                bubbles: true,
                cancelable: true,
                view: window
            });
            const touchEnd = new TouchEvent('touchend', {
                bubbles: true,
                cancelable: true,
                view: window
            });
            
            element.dispatchEvent(touchStart);
            element.dispatchEvent(touchEnd);
            
            const mouseDown = new MouseEvent('mousedown', {
                bubbles: true,
                cancelable: true,
                view: window
            });
            const mouseUp = new MouseEvent('mouseup', {
                bubbles: true,
                cancelable: true,
                view: window
            });
            const click = new MouseEvent('click', {
                bubbles: true,
                cancelable: true,
                view: window
            });
            
            element.dispatchEvent(mouseDown);
            element.dispatchEvent(mouseUp);
            element.dispatchEvent(click);
            
            return true;
        } catch (error) {
            return false;
        }
    }
    
    function isInAd() {
        const adText = document.querySelector('.ytp-ad-text');
        const adBadge = document.querySelector('.ytp-ad-preview-text');
        const adModule = document.querySelector('.ytp-ad-player-overlay-instream-info');
        
        return !!(adText || adBadge || adModule);
    }
    
    function checkTransitionSkipButton() {
        const now = Date.now();
        
        if (now - lastTransitionSkip < 500) return;
        
        const transitionSkipSelectors = [
            '.ytp-ad-skip-button-slot',
            '.ytp-ad-skip-button-container',
            '.ytp-ad-button-slot button',
            '.ytp-flyout-cta .ytp-button',
            'button.ytp-ad-overlay-close-button',
            '[aria-label*="Skip"]',
            '[aria-label*="skip"]'
        ];
        
        for (const selector of transitionSkipSelectors) {
            const skipBtn = document.querySelector(selector);
            
            if (skipBtn && skipBtn.offsetParent !== null) {
                if (!skipBtn.disabled && !skipBtn.classList.contains('ytp-ad-skip-button-disabled')) {
                    if (realClick(skipBtn)) {
                        adStats.transitionSkips++;
                        lastTransitionSkip = now;
                        logToApp(`⚡ Ad sequence skipped (Total: ${adStats.transitionSkips})`, 'success');
                        
                        setTimeout(forceVideoStart, 200);
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
    
    function getAdSequenceInfo() {
        const adText = document.querySelector('.ytp-ad-text');
        if (!adText) return null;
        
        const text = adText.textContent;
        const match = text.match(/(\d+)\s*of\s*(\d+)/i);
        
        if (match) {
            return {
                current: parseInt(match[1]),
                total: parseInt(match[2])
            };
        }
        return null;
    }
    
    function startPlaybackGuard() {
        if (ensurePlaybackInterval) {
            clearInterval(ensurePlaybackInterval);
        }
        
        let guardAttempts = 0;
        const maxAttempts = 20;
        
        ensurePlaybackInterval = setInterval(() => {
            const player = document.querySelector('video');
            
            if (!player) {
                clearInterval(ensurePlaybackInterval);
                return;
            }
            
            if (player.paused && !isInAd()) {
                player.play().catch(() => {});
                realClick(player);
            }
            
            guardAttempts++;
            
            if (guardAttempts >= maxAttempts || (!player.paused && player.currentTime > 0.5)) {
                clearInterval(ensurePlaybackInterval);
                ensurePlaybackInterval = null;
            }
        }, 200);
    }
    
    function forceVideoStart() {
        const player = document.querySelector('video');
        if (!player) return;
        
        try {
            player.playbackRate = 1;
            player.muted = false;
            
            if (player.currentTime < 0.5) {
                player.currentTime = 0;
            }
            
            player.play().then(() => {
                isProcessingMultipleAds = false;
                consecutiveAdChecks = 0;
                startPlaybackGuard();
            }).catch(() => {
                startPlaybackGuard();
            });
            
            realClick(player);
            
        } catch (error) {
        }
    }
    
    function skipAdTransition() {
        const player = document.querySelector('video');
        if (!player) return;
        
        try {
            if (checkTransitionSkipButton()) {
                return;
            }
            
            if (!isInAd() && (player.paused || player.seeking)) {
                player.play().catch(() => {});
                
                const skipButton = document.querySelector('.ytp-ad-skip-button, .ytp-ad-skip-button-modern');
                if (skipButton) {
                    realClick(skipButton);
                }
                
                setTimeout(forceVideoStart, 50);
            }
        } catch (error) {
        }
    }
    
    function handleAd() {
        try {
            const now = Date.now();
            const inAd = isInAd();
            const adInfo = getAdSequenceInfo();
            
            checkTransitionSkipButton();
            
            if (adInfo && adInfo.current === 1) {
                logToApp(`📺 ${adInfo.total} ads detected`, 'info');
                isProcessingMultipleAds = true;
            }
            
            if (wasInAd && !inAd) {
                consecutiveAdChecks++;
                
                if (consecutiveAdChecks < 10) {
                    skipAdTransition();
                    return;
                } else {
    
                    logToApp('✅ Video started', 'success');
                    forceVideoStart();
                    wasInAd = false;
                    consecutiveAdChecks = 0;
                    isProcessingMultipleAds = false;
                    return;
                }
            }
            
            if (inAd) {
                consecutiveAdChecks = 0;
                wasInAd = true;
            }
            
            if (!inAd) {
                if (isProcessingMultipleAds) {
                    skipAdTransition();
                }
                return;
            }
            
            if (now - lastAction < 300) return;
            
            const skipSelectors = [
                '.ytp-ad-skip-button',
                '.ytp-ad-skip-button-modern',
                '.ytp-skip-ad-button',
                'button[class*="skip"]',
                '.ytp-ad-skip-button-container button'
            ];
            
            for (const selector of skipSelectors) {
                const skipButton = document.querySelector(selector);
                if (skipButton && skipButton.offsetParent !== null) {
                    if (realClick(skipButton)) {
                        adStats.adsSkipped++;
                        lastAction = now;
                        logToApp(`⏭️ Ad skipped (Total: ${adStats.adsSkipped})`, 'success');
                        
                        if (!adInfo || adInfo.current === adInfo.total) {
                            setTimeout(forceVideoStart, 100);
                        }
                        return;
                    }
                }
            }
            
            const player = document.querySelector('video');
            if (player && player.duration > 0) {
                const remaining = player.duration - player.currentTime;
                
                if (player.duration < 120 && remaining > 0.2) {
                    player.currentTime = player.duration - 0.01;
                    player.playbackRate = 16;
                    player.muted = true;
                    adStats.adsFastForwarded++;
                    lastAction = now;
                    logToApp(`🚫 Ad blocked (Total: ${adStats.adsFastForwarded})`, 'success');
                    
                    setTimeout(() => {
                        player.playbackRate = 1;
                        if (!adInfo || adInfo.current === adInfo.total) {
                            forceVideoStart();
                        }
                    }, 50);
                }
            }
        } catch (error) {
          
            if (error.message.includes('critical')) {
                logToApp('Error: ' + error.message, 'error');
            }
        }
    }
    
    document.addEventListener('DOMContentLoaded', () => {
        const player = document.querySelector('video');
        if (player) {
            player.addEventListener('pause', () => {
                if (!isInAd() && player.currentTime < 5) {
                    setTimeout(() => {
                        if (!isInAd()) {
                            player.play();
                        }
                    }, 100);
                }
            });
        }
    });
    
    setInterval(handleAd, 150);
    
    const observer = new MutationObserver(handleAd);
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
    
})();
