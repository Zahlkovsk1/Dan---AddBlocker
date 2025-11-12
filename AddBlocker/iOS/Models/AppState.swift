//
//  AppState.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import SwiftUI
import Supabase
import Observation
import Network

@Observable
final class AppState {
    enum AuthState {
        case unauthenticated
        case authenticated
        case loading
    }
    
    private (set) var authState: AppState.AuthState = .loading
    private var streamTask: Task<Void, Never>?
    private let networkMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "networkMonitor")
    @ObservationIgnored private var isConnected: Bool = true
    
    init() {
        setupNetworkMonitor()
    }
    
    private func setupNetworkMonitor() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: monitorQueue)
    }
    
    func setAuthState(_ state: AuthState) {
        withAnimation {
            self.authState = state
        }
    }
    
    func startAuthListener(supabaseClient: SupabaseClient) {
        streamTask?.cancel()
        
        streamTask = Task { [weak self] in
            guard let self else { return }
            
            let localSession = supabaseClient.auth.currentSession
            
            if let _ = localSession {
                if isConnected {
                    let isValid = await Self.validateSession(serverWith: supabaseClient)
                    await MainActor.run {
                        withAnimation {
                            self.authState = isValid ? .authenticated : .unauthenticated
                        }
                    }
                } else {
                    await MainActor.run {
                        withAnimation {
                            self.authState = .authenticated
                        }
                    }
                }
            }  else {
                await MainActor.run {
                    withAnimation {
                        self.authState = .unauthenticated
                    }
                }
            }
            
            for await state in supabaseClient.auth.authStateChanges {
                if Task.isCancelled { break}
                if [.initialSession, .signedIn, .signedOut, .tokenRefreshed, .userUpdated, .userDeleted].contains(state.event) {
                    await MainActor.run {
                        withAnimation {
                            self.authState = (state.session != nil) ? .authenticated : .unauthenticated
                        }
                    }
                }
            }
        }
    }
    
    func stopAuthListener() {
        streamTask?.cancel()
        streamTask = nil
        networkMonitor.cancel()
    }
    
    private static func validateSession(serverWith client: SupabaseClient) async -> Bool {
        do {
            _ = try await client.auth.user()
            return true
        } catch {
            if let urlError = error as? URLError {
                if urlError.code == .notConnectedToInternet ||
                   urlError.code == .networkConnectionLost ||
                   urlError.code == .timedOut {
                    return true
                }
            }
            
            try? await client.auth.signOut()
            return false
        }
    }
}

