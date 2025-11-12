//
//  AddBlockerApp.swift
//  AddBlocker
//
//  Created by Gabons on 10/11/25.
//
import SwiftUI
import Supabase
import GoogleSignIn

@main
struct AddBlockerApp: App {
    private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RouterView(supabaseClient: SupabaseEnviromentKey.defaultValue)
            }
            .environment(appState)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
