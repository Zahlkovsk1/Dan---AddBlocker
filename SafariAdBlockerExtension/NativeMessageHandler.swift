//
//  NativeMessageHandler.swift
//  SafariAdBlockerExtension
//
//  Created by Gabons on 11/11/25.
//
import WebKit

class NativeMessageHandler: NSObject, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let body = message.body as? [String: Any] else { return }
        
        let messageText = body["message"] as? String ?? "Unknown message"
        let type = body["type"] as? String ?? "info"
        
        SharedLogger.shared.log(messageText, type: type, source: "extension")
    }
}
