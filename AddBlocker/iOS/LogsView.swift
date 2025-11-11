import SwiftUI

struct LogsView: View {
    @State private var logs: [SharedLogger.LogEntry] = []
    @State private var isAutoScrolling = true
    @State private var selectedFilter: LogFilter = .all
    
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    enum LogFilter: String, CaseIterable {
        case all = "All"
        case success = "Success"
        case info = "Info"
        case warning = "Warning"
        case error = "Error"
    }
    
    var filteredLogs: [SharedLogger.LogEntry] {
        switch selectedFilter {
        case .all:
            return logs
        case .success:
            return logs.filter { $0.type == "success" }
        case .info:
            return logs.filter { $0.type == "info" }
        case .warning:
            return logs.filter { $0.type == "warning" }
        case .error:
            return logs.filter { $0.type == "error" }
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(white: 0.08),
                    Color(white: 0.12),
                    Color(white: 0.08)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 0) {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Activity Monitor")
                                        .font(.system(size: 28, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    // Clear Button
                                    Button(action: clearLogs) {
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.white.opacity(0.9))
                                            .frame(width: 40, height: 40)
                                            .background(
                                                Circle()
                                                    .fill(.white.opacity(0.08))
                                                    .overlay(
                                                        Circle()
                                                            .stroke(.white.opacity(0.15), lineWidth: 1)
                                                    )
                                            )
                                    }
                                }
                                
                                // Stats Cards
                                let stats = SharedLogger.shared.getStats()
                                HStack(spacing: 10) {
                                    StatCard(
                                        icon: "checkmark.circle.fill",
                                        value: "\(stats.successes)",
                                        label: "Blocked"
                                    )
                                    
                                    StatCard(
                                        icon: "list.bullet",
                                        value: "\(stats.total)",
                                        label: "Total"
                                    )
                                    
                                    StatCard(
                                        icon: "exclamationmark.triangle.fill",
                                        value: "\(stats.errors)",
                                        label: "Errors"
                                    )
                                }
                                
                                // Filter Picker
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(LogFilter.allCases, id: \.self) { filter in
                                            FilterChip(
                                                title: filter.rawValue,
                                                isSelected: selectedFilter == filter
                                            ) {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    selectedFilter = filter
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 24)
                            .background(
                                GlassCard()
                            )
                            
                            // Logs List or Empty State
                            if filteredLogs.isEmpty {
                                VStack(spacing: 20) {
                                    Spacer()
                                        .frame(height: 100)
                                    
                                    ZStack {
                                        Circle()
                                            .fill(.white.opacity(0.05))
                                            .frame(width: 100, height: 100)
                                        
                                        Circle()
                                            .fill(.white.opacity(0.03))
                                            .frame(width: 80, height: 80)
                                        
                                        Image(systemName: "chart.line.downtrend.xyaxis")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white.opacity(0.4))
                                    }
                                    
                                    Text("No Activity")
                                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    Text("Open Safari and browse YouTube\nto see your ad blocker in action")
                                        .font(.system(size: 15, design: .rounded))
                                        .foregroundColor(.white.opacity(0.5))
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(4)
                                    
                                    Spacer()
                                        .frame(height: 100)
                                }
                            } else {
                                LazyVStack(spacing: 10) {
                                    ForEach(filteredLogs, id: \.id) { log in
                                        LogCard(log: log)
                                            .id(log.id)
                                            .transition(.asymmetric(
                                                insertion: .scale.combined(with: .opacity),
                                                removal: .opacity
                                            ))
                                    }
                                }
                                .padding(20)
                            }
                        }
                    }
                    .onChange(of: filteredLogs.count) { _ in
                        if isAutoScrolling, let firstLog = filteredLogs.first {
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo(firstLog.id, anchor: .top)
                            }
                        }
                    }
                }
                
                // Bottom Status Bar - Stays fixed at bottom
                if let latest = filteredLogs.first {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(.white)
                            .frame(width: 6, height: 6)
                            .shadow(color: .white.opacity(0.5), radius: 3)
                        
                        Text("Latest: \(latest.timestamp, style: .relative) ago")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text("\(filteredLogs.count) events")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        Rectangle()
                            .fill(.white.opacity(0.03))
                            .overlay(
                                Rectangle()
                                    .stroke(.white.opacity(0.08), lineWidth: 1)
                            )
                    )
                }
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
        withAnimation(.easeInOut(duration: 0.2)) {
            logs = SharedLogger.shared.getLogs()
        }
    }
    
    func clearLogs() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
            SharedLogger.shared.clearLogs()
            logs = []
        }
    }
}

// MARK: - Glass Card Background
struct GlassCard: View {
    var body: some View {
        Rectangle()
            .fill(.white.opacity(0.04))
            .overlay(
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(0.08),
                                .white.opacity(0.02)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                Rectangle()
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white.opacity(0.9))
            
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
        )
    }
}

// MARK: - Filter Chip
struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(isSelected ? .white : .white.opacity(0.5))
                .padding(.horizontal, 18)
                .padding(.vertical, 9)
                .background(
                    Capsule()
                        .fill(isSelected ? .white.opacity(0.15) : .white.opacity(0.05))
                        .overlay(
                            Capsule()
                                .stroke(.white.opacity(isSelected ? 0.2 : 0.1), lineWidth: 1)
                        )
                )
        }
    }
}

// MARK: - Log Card
struct LogCard: View {
    let log: SharedLogger.LogEntry
    
    var icon: String {
        if log.message.contains("✅") { return "checkmark.circle.fill" }
        if log.message.contains("🚫") { return "nosign" }
        if log.message.contains("⏭️") { return "forward.fill" }
        if log.message.contains("⚡") { return "bolt.fill" }
        if log.message.contains("📺") { return "tv.fill" }
        if log.message.contains("🎬") { return "play.circle.fill" }
        if log.message.contains("❌") { return "xmark.circle.fill" }
        if log.message.contains("⚠️") { return "exclamationmark.triangle.fill" }
        if log.message.contains("🔄") { return "arrow.triangle.2.circlepath" }
        if log.message.contains("▶️") { return "play.fill" }
        return "info.circle.fill"
    }
    
    var iconOpacity: Double {
        switch log.type {
        case "success": return 0.9
        case "error": return 0.8
        case "warning": return 0.7
        default: return 0.6
        }
    }
    
    var body: some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 42, height: 42)
                
                Image(systemName: icon)
                    .font(.system(size: 17))
                    .foregroundColor(.white.opacity(iconOpacity))
            }
            
            // Content
            VStack(alignment: .leading, spacing: 6) {
                Text(log.message)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.95))
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Text(log.timestamp, style: .time)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                    
                    Circle()
                        .fill(.white.opacity(0.25))
                        .frame(width: 3, height: 3)
                    
                    Text(log.source)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    LogsView()
}
