//
//  ContentView.swift
//  AddBlocker
//
//  Created by Gabons on 10/11/25.
//
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            LogsView()
                .tabItem {
                    Label("Logs", systemImage: "chart.bar.fill")
                }
                .tag(1)
            SettingsView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .tag(2)
        }
        .accentColor(.white)
        .preferredColorScheme(.dark)
    }
}
// MARK: - Home View
struct HomeView: View {
    @State private var isAnimating = false
    @State private var showWarning = true
    
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
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer()
                        .frame(height: 40)
                    
                    ShieldAnimationView()
                        .scaleEffect(showWarning ? 1.0 : 0.5)
                        .opacity(showWarning ? 1.0 : 0)
                    
                    Spacer()
                        .frame(height: 20)
                
                    VStack(spacing: 12) {
                        Text("YBlock")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("YouTube Ad Protection")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    if showWarning {
                        VStack(spacing: 16) {
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.orange)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Important Reminder")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                    
                                    Text("Safari may disable the extension when closed or updated. Make sure to re-enable it in Safari Settings.")
                                        .font(.system(size: 13, design: .rounded))
                                        .foregroundColor(.white.opacity(0.7))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                
                                Spacer()
                            }
                            
                            Button(action: openSettings) {
                                HStack(spacing: 8) {
                                    Image(systemName: "safari.fill")
                                        .font(.system(size: 14))
                                    
                                    Text("Open Safari Settings")
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(.orange.opacity(0.2))
                                        .overlay(
                                            Capsule()
                                                .stroke(.orange.opacity(0.4), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.orange.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // Feature Cards
                    VStack(spacing: 16) {
                        FeatureCard(
                            icon: "bolt.fill",
                            title: "Lightning Fast",
                            description: "Blocks ads instantly without slowing down"
                        )
                        
                        FeatureCard(
                            icon: "eye.slash.fill",
                            title: "Privacy First",
                            description: "No data collection, completely private"
                        )
                        
                        FeatureCard(
                            icon: "sparkles",
                            title: "Smart Detection",
                            description: "Automatically skips all ad sequences"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                showWarning = true
            }
        }
    }
    
    func openSettings() {
        if let url = URL(string: "App-prefs:SAFARI") {
            UIApplication.shared.open(url)
        }
    }
}



// MARK: - Feature Card
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.08))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    ContentView()
}
