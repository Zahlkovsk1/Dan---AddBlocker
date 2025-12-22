//
//  ProfileView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import SwiftUI
import Supabase

struct SettingsView: View {
    @Environment(AppState.self) var appState
    @Environment(\.dismiss) private var dismiss
    @State private var username: String = ""
    @State private var showDeleteConfirmation = false
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ZStack {
            Color(uiColor: UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark ? .black : .white
            })
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Circle()
                        .stroke(Color.primary, lineWidth: 2)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.title)
                                .foregroundColor(.primary)
                        )
                    
                    Text(username)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("YBlock Premium")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                VStack(spacing: 16) {
                    Button(action: {
                        if let url = URL(string: "https://mamadaliev.com") {
                            openURL(url)
                        }
                    }) {
                        Text("Support")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.primary.opacity(0.1))
                            .cornerRadius(16)
                    }
                    
                    Button(action: {
                        Task {
                            do {
                                try await SupabaseEnviromentKey.defaultValue.auth.signOut()
                                dismiss()
                            } catch {
                                print("error not logged out: \(error)")
                            }
                        }
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.primary.opacity(0.1))
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Delete Account Button - small and separated
                Button(action: {
                    showDeleteConfirmation = true
                }) {
                    Text("Delete Account")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.8))
                }
                .padding(.bottom, 16)
                
                VStack(spacing: 8) {
                    Text("By continuing, you agree to")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Link("Privacy Policy", destination: URL(string: "https://mamadaliev.com/privacy-policy")!)
                            .font(.caption)
                            .foregroundColor(.primary)
                        
                        Text("and")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Link("Terms & Conditions", destination: URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
            }
        }
        .task {
            await getUser()
        }
        .alert("Delete Account", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    await deleteAccount()
                }
            }
        } message: {
            Text("This action cannot be undone. All your data will be permanently deleted.")
        }
    }
    
    func getUser() async {
        do {
            let user = try await SupabaseEnviromentKey.defaultValue.auth.user()
            username = user.email ?? "Guest"
        } catch {
            print("Error fetching user: \(error)")
            username = "Guest"
        }
    }
    
    func deleteAccount() async {
        do {
            try await SupabaseEnviromentKey.defaultValue
                .functions
                .invoke("swift-handler")

            try await SupabaseEnviromentKey.defaultValue.auth.signOut()
            dismiss()
        } catch {
            print("Error deleting account: \(error)")
        }
    }
}
