//
//  RouterView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//
import SwiftUI
import Supabase

struct RouterView: View {
    var supabaseClient: SupabaseClient
    @Environment(AppState.self) var appState
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            if !hasCompletedOnboarding {
                OnboardingFlow()
            } else {
                switch appState.authState {
                case .authenticated:
                    ContentView()
                    
                case .unauthenticated:
                    LoginView(viewModel: AuthViewModel(appState: appState))
                    
                case .loading:
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
            }
        }
        .task {
            appState.startAuthListener(supabaseClient: supabaseClient)
        }
        // Add this: when onboarding completes, force auth state check
        .onChange(of: hasCompletedOnboarding) { oldValue, newValue in
            if newValue == true && oldValue == false {
                Task {
                    await checkInitialAuthState()
                }
            }
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


