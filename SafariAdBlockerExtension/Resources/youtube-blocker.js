// YouTube Mobile Ad Blocker 
(function() {
    'use strict';
    
    console.log('═══════════════════════════════════════════════');
    console.log('🚀 [CONTENT] YouTube Mobile AdBlocker loading...');
    console.log('═══════════════════════════════════════════════');
    
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
    
    // Minimal CSS
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
        console.log('✅ [CONTENT] CSS injected');
    } catch (error) {
        console.error('❌ [CONTENT] CSS error:', error);
    }
    
    // Simulate real click
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
    
    // Check for the transition/loading skip button
    function checkTransitionSkipButton() {
        const now = Date.now();
        
        if (now - lastTransitionSkip < 500) return;
        
        // Look for various skip button selectors that might appear during transition
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
            
            // Check if button exists and is visible
            if (skipBtn && skipBtn.offsetParent !== null) {
                // Check if it's not disabled
                if (!skipBtn.disabled && !skipBtn.classList.contains('ytp-ad-skip-button-disabled')) {
                    console.log(`🔘 [CONTENT] Transition skip button found: ${selector}`);
                    
                    if (realClick(skipBtn)) {
                        adStats.transitionSkips++;
                        lastTransitionSkip = now;
                        console.log(`⚡ [CONTENT] Transition skip clicked! Total: ${adStats.transitionSkips}`);
                        
                        // Force video start after transition skip
                        setTimeout(forceVideoStart, 200);
                        return true;
                    }
                }
            }
        }
        
        return false;
    }
    
    // Check if this is part of a multi-ad sequence
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
    
    // video playing continuously
    function startPlaybackGuard() {
        if (ensurePlaybackInterval) {
            clearInterval(ensurePlaybackInterval);
        }
        
        console.log('🛡️ [CONTENT] Starting playback guard');
        
        let guardAttempts = 0;
        const maxAttempts = 20;
        
        ensurePlaybackInterval = setInterval(() => {
            const player = document.querySelector('video');
            
            if (!player) {
                clearInterval(ensurePlaybackInterval);
                return;
            }
            
            if (player.paused && !isInAd()) {
                console.log(`▶️ [CONTENT] Forcing playback (${guardAttempts + 1}/${maxAttempts})`);
                
                player.play().catch(err => {
                    console.log('⚠️ [CONTENT] Play prevented:', err.message);
                });
                
                realClick(player);
            }
            
            guardAttempts++;
            
            if (guardAttempts >= maxAttempts || (!player.paused && player.currentTime > 0.5)) {
                console.log('✅ [CONTENT] Playback stabilized');
                clearInterval(ensurePlaybackInterval);
                ensurePlaybackInterval = null;
            }
        }, 200);
    }
    
    // Force video to start
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
                console.log('▶️ [CONTENT] Video started');
                isProcessingMultipleAds = false;
                consecutiveAdChecks = 0;
                startPlaybackGuard();
            }).catch(err => {
                console.log('⚠️ [CONTENT] Auto-play prevented:', err.message);
                startPlaybackGuard();
            });
            
            realClick(player);
            
        } catch (error) {
            console.error('❌ [CONTENT] Video start failed:', error);
        }
    }
    
    // Skip through the ad transition
    function skipAdTransition() {
        const player = document.querySelector('video');
        if (!player) return;
        
        try {
            // click the transition skip button
            if (checkTransitionSkipButton()) {
                return; // Skip button clicked, we're done
            }
            
            if (!isInAd() && (player.paused || player.seeking)) {
                console.log('⏩ [CONTENT] Skipping ad transition');
                
                player.play().catch(() => {});
                
                const skipButton = document.querySelector('.ytp-ad-skip-button, .ytp-ad-skip-button-modern');
                if (skipButton) {
                    realClick(skipButton);
                }
                
                setTimeout(forceVideoStart, 50);
            }
        } catch (error) {
            console.error('❌ [CONTENT] Transition skip error:', error);
        }
    }
    
    // Main ad handling
    function handleAd() {
        try {
            const now = Date.now();
            const inAd = isInAd();
            const adInfo = getAdSequenceInfo();
            
            // check for transition skip button
            checkTransitionSkipButton();
            
            if (adInfo) {
                console.log(`📺 [CONTENT] Ad ${adInfo.current} of ${adInfo.total}`);
                isProcessingMultipleAds = true;
            }
            
            if (wasInAd && !inAd) {
                consecutiveAdChecks++;
                
                if (consecutiveAdChecks < 10) {
                    console.log(`🔄 [CONTENT] Checking for next ad... (${consecutiveAdChecks}/10)`);
                    skipAdTransition();
                    return;
                } else {
                    console.log('🎬 [CONTENT] All ads done!');
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
            
            // Try regular skip button
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
                        console.log(`⏭️ [CONTENT] Skip clicked! Total: ${adStats.adsSkipped}`);
                        
                        if (!adInfo || adInfo.current === adInfo.total) {
                            setTimeout(forceVideoStart, 100);
                        }
                        return;
                    }
                }
            }
            
            // Fast-forward ad
            const player = document.querySelector('video');
            if (player && player.duration > 0) {
                const remaining = player.duration - player.currentTime;
                
                if (player.duration < 120 && remaining > 0.2) {
                    player.currentTime = player.duration - 0.01;
                    player.playbackRate = 16;
                    player.muted = true;
                    adStats.adsFastForwarded++;
                    lastAction = now;
                    console.log(`🚫 [CONTENT] Ad fast-forwarded! Total: ${adStats.adsFastForwarded}`);
                    
                    setTimeout(() => {
                        player.playbackRate = 1;
                        if (!adInfo || adInfo.current === adInfo.total) {
                            forceVideoStart();
                        }
                    }, 50);
                }
            }
        } catch (error) {
            console.error('❌ [CONTENT] Error:', error);
        }
    }
    
    // Listen for pause events
    document.addEventListener('DOMContentLoaded', () => {
        const player = document.querySelector('video');
        if (player) {
            player.addEventListener('pause', () => {
                if (!isInAd() && player.currentTime < 5) {
                    console.log('🔄 [CONTENT] Auto-pause detected - resuming');
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
    
    // DOM changes
    const observer = new MutationObserver(handleAd);
    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
    
    console.log('✅ [CONTENT] AdBlocker initialized');
    console.log('═══════════════════════════════════════════════');
    
})();
