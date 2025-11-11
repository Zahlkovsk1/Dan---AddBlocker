//
//  LogsView.swift
//  AddBlocker
//
//  Created by Gabons on 11/11/25.
//
import SwiftUI

struct LogsView: View {
    @State private var logs: [SharedLogger.LogEntry] = []
    @State private var isAutoScrolling = true
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Extension Logs")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                let stats = SharedLogger.shared.getStats()
                HStack(spacing: 12) {
                    Label("\(stats.total)", systemImage: "list.bullet")
                        .font(.caption)
                    Label("\(stats.successes)", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    Label("\(stats.errors)", systemImage: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Button(action: clearLogs) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            
            Divider()
            
            // Logs list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        if logs.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "text.alignleft")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)
                                
                                Text("No logs yet")
                                    .foregroundColor(.gray)
                                
                                Text("Open Safari and browse YouTube to see activity")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                        } else {
                            ForEach(logs, id: \.id) { log in
                                LogRowView(log: log)
                                    .id(log.id)
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: logs.count) { _ in
                    if isAutoScrolling, let firstLog = logs.first {
                        withAnimation {
                            proxy.scrollTo(firstLog.id, anchor: .top)
                        }
                    }
                }
            }

            if let latest = logs.first {
                Divider()
                HStack {
                    Label("\(logs.count)", systemImage: "list.bullet")
                    Spacer()
                    Text("Latest: \(latest.timestamp, style: .relative) ago")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
            }
        }
        .onReceive(timer) { _ in
            refreshLogs()
        }
        .onAppear {
            refreshLogs()
        }
    }
    
    func refreshLogs() {
        logs = SharedLogger.shared.getLogs()
    }
    
    func clearLogs() {
        SharedLogger.shared.clearLogs()
        logs = []
    }
    
    
}

struct LogRowView: View {
    let log: SharedLogger.LogEntry
    
    var icon: String {
        if log.message.contains("✅") { return "✅" }
        if log.message.contains("🚫") { return "🚫" }
        if log.message.contains("⏭️") { return "⏭️" }
        if log.message.contains("⚡") { return "⚡" }
        if log.message.contains("📺") { return "📺" }
        if log.message.contains("🎬") { return "🎬" }
        if log.message.contains("❌") { return "❌" }
        if log.message.contains("⚠️") { return "⚠️" }
        if log.message.contains("🔄") { return "🔄" }
        if log.message.contains("▶️") { return "▶️" }
        return "ℹ️"
    }
    
    var color: Color {
        switch log.type {
        case "success": return .green
        case "error": return .red
        case "warning": return .orange
        default: return .primary
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(log.message)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(color)
                
                HStack {
                    Text(log.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text(log.source)
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    LogsView()
}
