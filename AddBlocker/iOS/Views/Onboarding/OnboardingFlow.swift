//
//  OnboardingFlow.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import SwiftUI

struct OnboardingFlow: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            switch currentPage {
            case 0:
                OnboardingWelcomeView {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        currentPage = 1
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
            case 1:
                OnboardingBenefitsView {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        currentPage = 2
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
            case 2:
                OnboardingFeaturesView {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        currentPage = 3
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
            case 3:
                OnboardingPaywallView {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        hasCompletedOnboarding = true
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
            default:
                EmptyView()
            }
        }
    }
}
