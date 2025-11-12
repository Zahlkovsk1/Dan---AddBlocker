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
                    
                    Text("AddBlock Premium")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                VStack(spacing: 16) {
                    Button(action: {
                       
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
                
                VStack(spacing: 8) {
                    Text("By continuing, you agree to")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Link("Privacy Policy", destination: URL(string: "https://mamadaliev.com/")!)
                            .font(.caption)
                            .foregroundColor(.primary)
                        
                        Text("and")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Link("Terms & Conditions", destination: URL(string: "https://mamadaliev.com/")!)
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
}
