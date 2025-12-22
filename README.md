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
