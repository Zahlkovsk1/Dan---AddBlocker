<p align="center">
<img src="assets/app-icon.png" alt="YBlock Icon" width="120" height="120">
<h1 align="center">YBlock</h1>
<p align="center">Safari Ad Blocker Extension</p>
</p>
  
<p align="center">
   <img src="assets/Frame 4.png" alt="iOS 18+" height="35" style="margin: 0 12px;">
   <img src="assets/Frame 5.png" alt="SwiftUI" height="35" style="margin: 0 12px;">
   <img src="assets/Frame 6.png" alt="JavaScript" height="35" style="margin: 0 12px;">
   <img src="assets/Frame 7.png" alt="Safari Extension" height="35" style="margin: 0 12px;">
</p>
  
  <p  align="center" >
   <a href="https://apps.apple.com/it/app/yblock/id6755256321">
  <img src="https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg" alt="Download on the App Store" width="140"/>
</a>
  </p>
  
---

# YBlock - Safari Ad Blocker Extension

A lightweight and efficient ad blocker extension for Safari, built with Swift and JavaScript to provide a seamless browsing experience free from intrusive advertisements.

## Features

- **Native Safari Integration** - Leverages Safari's Content Blocker API
- **Privacy-First** - All blocking happens locally; no data is sent to external servers
- **Customizable Rules** - Flexible blocking rules powered by JSON configuration
- **Minimal Resource Usage** - Efficient implementation using Safari's native content blocking framework
- **Activity Logging** - Tracks and displays blocked content so user can see what has been filtered in real-time.

## How It Works

YBlock uses Safari's Content Blocker API, which compiles blocking rules into bytecode for efficient execution. The extension:

1. Loads JSON-based blocking rules when Safari starts
2. Safari compiles these rules into optimized bytecode
3. Rules are applied automatically as you browse
4. Logs blocked content for user visibility and transparency

## Architecture

YBlock utilizes Safari's Content Blocker Extension framework, which consists of:

- **Swift-based Extension** - Handles the extension lifecycle and rule management
- **JavaScript Components** - Custom scripts for advanced blocking scenarios
- **JSON Rule Configuration** - Declarative blocking rules with triggers and actions
- **Native iOS UI** - User Interfaces built with SwiftUI

## Author

Developed by [@Zahlkovsk1](https://github.com/Zahlkovsk1)

**Note**: YBlock respects user privacy and does not collect any browsing data. All ad blocking happens locally on your device.
