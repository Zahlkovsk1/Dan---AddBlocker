//
//  RouterView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
/**
 * # RouterView
 *
 * The primary routing engine for the application. This view determines the correct
 * destination screen based on the user's three key states:
 * 1.  **Onboarding Status** (`@AppStorage("hasCompletedOnboarding")`)
 * 2.  **Subscription Status** (`StoreManager.shared.isPremium`)
 * 3.  **Authentication Status** (`AppState.authState` - Supabase session)
 *
 * ## Primary Logic Flow:
 * The routing logic prioritizes status checks in the following order:
 *
 * 1.  **Loading State:** If Supabase is checking the session (`appState.authState == .loading`), display a loading spinner.
 *
 * 2.  **First-Time User:** If the user has NOT completed onboarding AND they are NOT a known premium subscriber (fresh install), show the `OnboardingFlow`.
 * - *Condition:* `!hasCompletedOnboarding && !storeManager.isPremium`
 *
 * 3.  **Authentication:** Once checks are complete (or bypassed), route based on the Supabase session:
 * - **.authenticated:** User is signed in. Go to `ContentView`.
 * - **.unauthenticated:** User is not signed in. Go to `LoginView`.
 * - *Note:* If the user is unauthenticated but `storeManager.isPremium` is TRUE (from a fresh install/restore), the `LoginView` should prompt them to log in or register to sync their subscription benefits with their account.
 *
 * ## Silent Purchase Restoration:
 * The `.task` modifier ensures that the application silently checks for an active subscription
 * via StoreKit 2 (`storeManager.updateSubscriptionStatus()`) immediately upon launch.
 * This prevents paying subscribers from seeing the Onboarding or Paywall screens upon app reinstallation.
 * * The `hasCompletedOnboarding` flag is automatically set to `true` if a subscription
 * is found on a fresh install to persist the bypass state.
 */

import SwiftUI
import Supabase
import StoreKit // 1. Import StoreKit

struct RouterView: View {
    var supabaseClient: SupabaseClient
    @Environment(AppState.self) var appState
    @State private var storeManager = StoreManager.shared
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            if appState.authState == .loading {
                loadingView
            }
            
            else if !hasCompletedOnboarding && !storeManager.isPremium {
                OnboardingFlow()
            }
            else {
                switch appState.authState {
                case .authenticated:
                    ContentView()
                    
                case .unauthenticated:
                 
                    LoginView(viewModel: AuthViewModel(appState: appState))
                    
                case .loading:
                    loadingView
                }
            }
        }
        .task {
            
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    appState.startAuthListener(supabaseClient: supabaseClient)
                }
                group.addTask {
                    await storeManager.updateSubscriptionStatus()
                }
            }
            
            if storeManager.isPremium && !hasCompletedOnboarding {
                hasCompletedOnboarding = true
            }
        }
        .onChange(of: hasCompletedOnboarding) { oldValue, newValue in
            if newValue == true && oldValue == false {
                Task {
                    await checkInitialAuthState()
                }
            }
        }
    }
    
    var loadingView: some View {
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
            
            ProgressView()
                .tint(.white)
        }
    }

    private func checkInitialAuthState() async {
        let session = supabaseClient.auth.currentSession
        
        await MainActor.run {
            if session != nil {
                appState.setAuthState(.authenticated)
            } else {
                appState.setAuthState(.unauthenticated)
            }
        }
    }
}


