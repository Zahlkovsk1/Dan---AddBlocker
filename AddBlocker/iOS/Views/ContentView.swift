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
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.05))
                            .frame(width: 140, height: 140)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                        
                        Circle()
                            .fill(.white.opacity(0.08))
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "shield.lefthalf.filled")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.95))
                    }
                    .padding(.top, 20) // Add padding instead of Spacer
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }
                    
                    VStack(spacing: 12) {
                        Text("AdBlocker")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("YouTube Ad Protection")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
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
                    
                    VStack(spacing: 20) {
                        VStack(spacing: 12) {
                            Image(systemName: "gearshape.2.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text("Setup Required")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Enable extensions in Safari settings to start blocking ads")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(.white.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 20)
                        }
                        
                        Button(action: openSettings) {
                            HStack(spacing: 8) {
                                Image(systemName: "safari.fill")
                                    .font(.system(size: 16))
                                
                                Text("Open Safari Settings")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(.white.opacity(0.15))
                                    .overlay(
                                        Capsule()
                                            .stroke(.white.opacity(0.25), lineWidth: 1)
                                    )
                            )
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white.opacity(0.05))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.12), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    // Bottom padding for tab bar
                    Spacer()
                        .frame(height: 20)
                }
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
