//
//  OnboardingBenefitsView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//
import SwiftUI

struct OnboardingBenefitsView: View {
    @State private var showContent = false
    @State private var showComparison = false
    @State private var selectedMode: ComparisonMode = .before
    
    var onContinue: () -> Void
    
    enum ComparisonMode {
        case before, after
    }
    
    var body: some View {
        ZStack {
            // Monochrome Gradient Background
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
                
                // Main Title
                VStack(spacing: 12) {
                    Text("Block All")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    Text("YouTube Ads")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.9))
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }
                
                Spacer()
                    .frame(height: 50)
                
                // Visual Comparison
                VStack(spacing: 24) {
                    // Toggle Buttons
                    HStack(spacing: 12) {
                        ComparisonButton(
                            title: "Before",
                            icon: "xmark.circle.fill",
                            isSelected: selectedMode == .before
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedMode = .before
                            }
                        }
                        
                        ComparisonButton(
                            title: "After",
                            icon: "checkmark.circle.fill",
                            isSelected: selectedMode == .after
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedMode = .after
                            }
                        }
                    }
                    .opacity(showComparison ? 1 : 0)
                    .offset(y: showComparison ? 0 : 20)
                    
                    // Comparison Visual
                    ZStack {
                        if selectedMode == .before {
                            BeforeView()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .trailing).combined(with: .opacity)
                                ))
                        } else {
                            AfterView()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        }
                    }
                    .frame(height: 280)
                    .opacity(showComparison ? 1 : 0)
                    .scaleEffect(showComparison ? 1 : 0.9)
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Bottom Text
                VStack(spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("Instant blocking, zero interruptions")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.08))
                            .overlay(
                                Capsule()
                                    .stroke(.white.opacity(0.15), lineWidth: 1)
                            )
                    )
                    .opacity(showComparison ? 1 : 0)
                    .offset(y: showComparison ? 0 : 20)
                }
                .padding(.bottom, 20)
                
                // Continue Button
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        onContinue()
                    }
                }) {
                    HStack(spacing: 12) {
                        Text("Continue")
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
                .opacity(showComparison ? 1 : 0)
                .scaleEffect(showComparison ? 1 : 0.9)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.1)) {
                showContent = true
            }
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5)) {
                showComparison = true
            }
            
            // Auto-switch to "After" view after 1.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    selectedMode = .after
                }
            }
        }
    }
}

// MARK: - Comparison Button
struct ComparisonButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.5))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? .white.opacity(0.15) : .white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.white.opacity(isSelected ? 0.25 : 0.12), lineWidth: 1)
                    )
            )
        }
    }
}

// MARK: - Before View (With Ads)
struct BeforeView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Video representation
            VStack(spacing: 0) {
                // Ad banner on top
                HStack {
                    Text("Ad")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.4))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.1))
                        )
                    
                    Spacer()
                }
                .padding(12)
                .background(Color.white.opacity(0.05))
                
                // Video area
                ZStack {
                    Rectangle()
                        .fill(.white.opacity(0.03))
                    
                    Image(systemName: "play.tv.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.2))
                }
                .frame(height: 160)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Problems list
            VStack(alignment: .leading, spacing: 12) {
                ProblemRow(icon: "xmark.circle.fill", text: "5-15 second forced ads")
                ProblemRow(icon: "xmark.circle.fill", text: "Multiple ad sequences")
                ProblemRow(icon: "xmark.circle.fill", text: "Interrupts your viewing")
            }
        }
    }
}

// MARK: - After View (No Ads)
struct AfterView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Clean video representation
            VStack(spacing: 0) {
                // Clean top bar
                HStack {
                    Image(systemName: "shield.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("Protected")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                    
                    Spacer()
                }
                .padding(12)
                .background(Color.white.opacity(0.08))
                
                // Video area - clean
                ZStack {
                    Rectangle()
                        .fill(.white.opacity(0.06))
                    
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(height: 160)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Benefits list
            VStack(alignment: .leading, spacing: 12) {
                BenefitRow(icon: "checkmark.circle.fill", text: "Zero ads, instant play")
                BenefitRow(icon: "checkmark.circle.fill", text: "Uninterrupted viewing")
                BenefitRow(icon: "checkmark.circle.fill", text: "Fast & seamless")
            }
        }
    }
}

// MARK: - Problem Row
struct ProblemRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.4))
            
            Text(text)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.white.opacity(0.5))
            
            Spacer()
        }
    }
}

// MARK: - Benefit Row
struct BenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
            
            Text(text)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingBenefitsView {
        print("Continue tapped")
    }
}

