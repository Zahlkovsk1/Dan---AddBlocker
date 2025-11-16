//
//  PayWallView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//
//
//  OnboardingPaywallView.swift
//  YBlock
//
//  Created by Gabons on 14/11/25.
//

import SwiftUI
import StoreKit

struct OnboardingPaywallView: View {
    @State private var storeManager = StoreManager.shared
    @State private var showContent = false
    @State private var selectedPlan: SubscriptionPlan = .yearly
    @State private var showError = false
    @State private var errorMessage = ""
    
    var onComplete: () -> Void
    
    enum SubscriptionPlan {
        case monthly, yearly
        
        var price: String {
            switch self {
            case .monthly: return "$0.99"
            case .yearly: return "$9.99"
            }
        }
        
        var perMonth: String {
            switch self {
            case .monthly: return "$0.99/mo"
            case .yearly: return "$0.83/mo"
            }
        }
        
        var savings: String? {
            switch self {
            case .monthly: return nil
            case .yearly: return "Save 16%"
            }
        }
        
        var title: String {
            switch self {
            case .monthly: return "Monthly"
            case .yearly: return "Yearly"
            }
        }
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
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: 60)
                    
                    // Shield Icon
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.12),
                                        Color.white.opacity(0.05),
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 120, height: 120)
                            .blur(radius: 15)
                        
                        Image(systemName: "shield.lefthalf.filled")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.95))
                    }
                    .scaleEffect(showContent ? 1 : 0.5)
                    .opacity(showContent ? 1 : 0)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    // Title
                    VStack(spacing: 12) {
                        Text("Start Your")
                            .font(.system(size: 17, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Text("Premium Access")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("Block all YouTube ads instantly")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // Subscription Plans
                    VStack(spacing: 12) {
                        PlanCard(
                            plan: .yearly,
                            isSelected: selectedPlan == .yearly
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedPlan = .yearly
                            }
                        }
                        
                        PlanCard(
                            plan: .monthly,
                            isSelected: selectedPlan == .monthly
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedPlan = .monthly
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    
                    Spacer()
                        .frame(height: 32)
                    
                    // What's Included
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What's Included")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            IncludedFeature(
                                icon: "bolt.fill",
                                text: "Block all YouTube ads instantly"
                            )
                            
                            IncludedFeature(
                                icon: "shield.fill",
                                text: "100% privacy protection"
                            )
                            
                            IncludedFeature(
                                icon: "arrow.clockwise",
                                text: "Regular updates & improvements"
                            )
                            
                            IncludedFeature(
                                icon: "checkmark.seal.fill",
                                text: "Premium support"
                            )
                        }
                        .padding(.horizontal, 24)
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                    
                    Spacer()
                        .frame(height: 40)
                    
                    // Trial Info
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(.green)
                            
                            Text("Billed \(selectedPlan.price)/\(selectedPlan == .yearly ? "year" : "month")")
                                .font(.system(size: 13, design: .rounded))
                        }
                        .foregroundColor(.white.opacity(0.6))
                        
                        Text("Cancel anytime")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .opacity(showContent ? 1 : 0)
                    
                    Spacer()
                        .frame(height: 24)
                    
                    // Subscribe Button
                    Button(action: handleSubscribe) {
                        HStack(spacing: 12) {
                            if storeManager.isLoading {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Continue")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(.white.opacity(0.2))
                                .overlay(
                                    Capsule()
                                        .stroke(.white.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .disabled(storeManager.isLoading || storeManager.monthlyProduct == nil)
                    .padding(.horizontal, 24)
                    .opacity(showContent ? 1 : 0)
                    .scaleEffect(showContent ? 1 : 0.9)
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // Legal Links
                    HStack(spacing: 16) {
                        Button("Terms of Use") {
                            // Open terms
                        }
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                        
                        Text("•")
                            .foregroundColor(.white.opacity(0.3))
                        
                        Button("Privacy Policy") {
                            // Open privacy
                        }
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                        
                        Text("•")
                            .foregroundColor(.white.opacity(0.3))
                        
                        Button("Restore") {
                            Task {
                                await storeManager.restorePurchases()
                                if storeManager.isPremium {
                                    onComplete()
                                }
                            }
                        }
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white.opacity(0.5))
                    }
                    .opacity(showContent ? 1 : 0)
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .alert("Purchase Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.1)) {
                showContent = true
            }
        }
    }
    
    func handleSubscribe() {
        Task {
            do {
                // Both options purchase the same monthly subscription
                let success = try await storeManager.purchase()
                if success {
                    onComplete()
                }
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}

// MARK: - Plan Card
struct PlanCard: View {
    let plan: OnboardingPaywallView.SubscriptionPlan
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Selection Indicator
                ZStack {
                    Circle()
                        .stroke(.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(.white)
                            .frame(width: 14, height: 14)
                    }
                }
                
                // Plan Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(plan.title)
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                        
                        if let savings = plan.savings {
                            Text(savings)
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(.white.opacity(0.2))
                                )
                        }
                    }
                    
                    Text(plan.perMonth)
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Price
                Text(plan.price)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .white.opacity(0.12) : .white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white.opacity(isSelected ? 0.25 : 0.12), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
    }
}

// MARK: - Included Feature
struct IncludedFeature: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.9))
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
    }
}
