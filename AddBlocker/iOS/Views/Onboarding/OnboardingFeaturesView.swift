//
//  OnboardingFeaturesView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import SwiftUI

struct OnboardingFeaturesView: View {
    @State private var showTitle = false
    @State private var selectedFeature = 0
    @State private var showButton = false
    
    var onContinue: () -> Void
    
    let features = [
        Feature(
            icon: "bolt.fill",
            title: "Fast",
            subtitle: "Lightning Speed",
            description: "Blocks ads instantly\nNo delays or buffering",
            color: Color.white.opacity(0.9)
        ),
        Feature(
            icon: "lock.shield.fill",
            title: "Private",
            subtitle: "Zero Tracking",
            description: "No data collection\nYour privacy protected",
            color: Color.white.opacity(0.85)
        ),
        Feature(
            icon: "checkmark.seal.fill",
            title: "Effective",
            subtitle: "100% Coverage",
            description: "Every ad type blocked\nSeamless experience",
            color: Color.white.opacity(0.9)
        )
    ]
    
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
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 8) {
                    Text("Why Choose")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .opacity(showTitle ? 1 : 0)
                        .offset(y: showTitle ? 0 : 20)
                    
                    Text("YBlocker?")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(showTitle ? 1 : 0)
                        .offset(y: showTitle ? 0 : 20)
                }
                
                Spacer()
                    .frame(height: 50)
                
                TabView(selection: $selectedFeature) {
                    ForEach(0..<features.count, id: \.self) { index in
                        FeatureCardOnboarding(feature: features[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 380)
                
                HStack(spacing: 8) {
                    ForEach(0..<features.count, id: \.self) { index in
                        Circle()
                            .fill(selectedFeature == index ? Color.white.opacity(0.9) : Color.white.opacity(0.3))
                            .frame(width: selectedFeature == index ? 8 : 6, height: selectedFeature == index ? 8 : 6)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedFeature)
                    }
                }
                .padding(.top, 20)
                
                Spacer()
                
                HStack(spacing: 16) {
                    ForEach(features, id: \.title) { feature in
                        VStack(spacing: 6) {
                            Image(systemName: feature.icon)
                                .font(.system(size: 18))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(feature.title)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.white.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.12), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 32)
                .opacity(showButton ? 1 : 0)
                .offset(y: showButton ? 0 : 20)
                
                Spacer()
                    .frame(height: 24)
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        onContinue()
                    }
                }) {
                    HStack(spacing: 12) {
                        Text("Start Blocking Ads")
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.15))
                            .overlay(
                                Capsule()
                                    .stroke(.white.opacity(0.25), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
                .opacity(showButton ? 1 : 0)
                .scaleEffect(showButton ? 1 : 0.9)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.1)) {
                showTitle = true
            }
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.6)) {
                showButton = true
            }
            
            startAutoAdvance()
        }
    }
    
    func startAutoAdvance() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                selectedFeature = (selectedFeature + 1) % features.count
            }
        }
    }
}


struct Feature {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    let color: Color
}

// MARK: - Feature Card
struct FeatureCardOnboarding: View {
    let feature: Feature
    @State private var showContent = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Icon with glow effect
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.15),
                                Color.white.opacity(0.05),
                                Color.clear
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 80
                        )
                    )
                    .frame(width: 160, height: 160)
                    .blur(radius: 20)
                
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 110, height: 110)
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.15), lineWidth: 1)
                    )
                
                Image(systemName: feature.icon)
                    .font(.system(size: 50))
                    .foregroundColor(feature.color)
                    .shadow(color: .white.opacity(0.3), radius: 10)
            }
            .scaleEffect(showContent ? 1 : 0.5)
            .opacity(showContent ? 1 : 0)
            
            Spacer()
                .frame(height: 40)
            
            Text(feature.title)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
            
            Text(feature.subtitle)
                .font(.system(size: 17, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
                .padding(.top, 4)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
            
            Spacer()
                .frame(height: 24)
            
            Text(feature.description)
                .font(.system(size: 16, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, 40)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
            
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75)) {
                showContent = true
            }
        }
    }
}

#Preview {
    OnboardingFeaturesView {
        print("Continue tapped")
    }
}

