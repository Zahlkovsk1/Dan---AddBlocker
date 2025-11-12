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
    var body: some View {
        ZStack {
            switch appState.authState {
            case .authenticated:
                ContentView()
            case .unauthenticated:
                LoginView(viewModel: AuthViewModel(appState: appState))
            case .loading:
                ProgressView()
            }
        }
        .task{
            appState.startAuthListener(supabaseClient: supabaseClient)
        }
        
    }
}
