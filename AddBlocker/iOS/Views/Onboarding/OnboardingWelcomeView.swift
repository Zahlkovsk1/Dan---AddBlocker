//
//  OnboardingWelcomeView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    @State private var showContent = false
    @State private var showButton = false
    
    var onContinue: () -> Void
    
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
                
                ShieldAnimationView()
                    .scaleEffect(showContent ? 1.0 : 0.5)
                    .opacity(showContent ? 1.0 : 0)
                
                Spacer()
                    .frame(height: 60)
            
                VStack(spacing: 16) {
                    Text("Welcome to")
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    Text("YBlocker")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                    
                    Text("Your shield against\nYouTube ads")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.top, 8)
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 20)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        onContinue()
                    }
                }) {
                    HStack(spacing: 12) {
                        Text("Get Started")
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
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.2)) {
                showContent = true
            }
            
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.8)) {
                showButton = true
            }
        }
    }
}

#Preview {
    OnboardingWelcomeView {
        print("Continue tapped")
    }
}

