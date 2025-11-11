//
//  SharedLogger.swift
//  AddBlocker
//
//  Created by Gabons on 11/11/25.
//

import Foundation
class SharedLogger {
    static let shared = SharedLogger()
    private let appGroupID = "group.com.shox.adblocker"
    private let logsKey = "extensionLogs"
    private let maxLogs = 200
    
    private var userDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupID)
    }
    
    struct LogEntry: Codable {
        let id: String
        let message: String
        let type: String
        let timestamp: Date
        let source: String
        
        init(message: String, type: String, source: String) {
            self.id = UUID().uuidString
            self.message = message
            self.type = type
            self.timestamp = Date()
            self.source = source
        }
    }
    
    func log(_ message: String, type: String = "info", source: String = "extension") {
        guard let defaults = userDefaults else {
            print("❌ Failed to access UserDefaults with app group")
            return
        }
        
        var logs = getLogs()
        
        let newLog = LogEntry(message: message, type: type, source: source)
        logs.insert(newLog, at: 0)
        
        if logs.count > maxLogs {
            logs = Array(logs.prefix(maxLogs))
        }
        
        // Save back to UserDefaults
        if let encoded = try? JSONEncoder().encode(logs) {
            defaults.set(encoded, forKey: logsKey)
            defaults.synchronize() // Force sync
        }
        
        print(message)
    }
    
    // Get all logs
    func getLogs() -> [LogEntry] {
        guard let defaults = userDefaults,
              let data = defaults.data(forKey: logsKey),
              let logs = try? JSONDecoder().decode([LogEntry].self, from: data) else {
            return []
        }
        return logs
    }
    
    // Clear all logs
    func clearLogs() {
        userDefaults?.removeObject(forKey: logsKey)
        userDefaults?.synchronize()
    }
    
    // Get stats
    func getStats() -> (total: Int, successes: Int, errors: Int, warnings: Int) {
        let logs = getLogs()
        return (
            total: logs.count,
            successes: logs.filter { $0.type == "success" }.count,
            errors: logs.filter { $0.type == "error" }.count,
            warnings: logs.filter { $0.type == "warning" }.count
        )
    }
}
