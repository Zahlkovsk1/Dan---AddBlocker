//
//  AuthViewModel.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//
import SwiftUI
import Supabase
import GoogleSignIn

@Observable
final class AuthViewModel  {
    var showSignUp = false
    var userEmail: String = ""
    var userPassword: String = ""
    var otpCode: String = ""
    var isAwaitingOTP = false
    var pendingEmail: String = ""
    var isAuthenticated = false
    var isLoading = false
    var isShowingAllert = false
    var alertMessage: String = ""
    
    var authResult: Result<Void, Error>? {
        didSet {
            if case .failure(let error) = authResult {
                alertMessage = error.localizedDescription
                showAllert()
            }
        }
    }
    // for button disabling
    var isValid: Bool {
        !userEmail.isEmpty && !userPassword.isEmpty
    }
    
    let appState : AppState
    init(appState: AppState) {
        self.appState = appState
    }

    func showAllert() {
        isShowingAllert = true
    }
    
    func toggleLoaidngState() {
        withAnimation {
            isLoading.toggle()
        }
    }
    
    //MARK: - Authentication Methods
    
    func handleGoogleSignInButtonTapped() {
        Task {
            await signInWithGoogle(using: SupabaseClient.development)
        }
    }
    
    func handleSingInButtonTapped() {
        guard isValid else {
            alertMessage = "please enter your mail and password"
            showAllert()
            return
        }
        Task {
            await singIn(using: SupabaseClient.development)
        }
    }
    
    private func singIn(using supbaseClient: SupabaseClient) async {
        toggleLoaidngState()
        defer {
            toggleLoaidngState()
        }
        do  {
            try await supbaseClient.auth.signIn(email: userEmail , password: userPassword)
            authResult = .success(())

            appState.setAuthState(.authenticated)
            
        } catch {
            authResult = .failure(error)
        }
    }
    //MARK: Registering
    
    func handleSingUpButtonTapped() {
        guard isValid else {
            alertMessage = "please enter your mail and password"
            showAllert()
            return
        }
        Task {
            await singUp(using: SupabaseClient.development)
        }
    }
    
    private func singUp(using supbaseClient: SupabaseClient) async {
        toggleLoaidngState()
        defer {
            toggleLoaidngState()
        }
        do  {
            try await supbaseClient.auth.signUp(email: userEmail , password: userPassword)
            authResult = .success(())
            await singIn(using: SupabaseClient.development)
            
        } catch {
            authResult = .failure(error)
        }
    }
    
    private func signInWithGoogle(using supabaseClient: SupabaseClient) async {
        toggleLoaidngState()
        defer {
            toggleLoaidngState()
        }
        
        do {
            guard let rootViewController = getRootViewController() else {
                throw NSError(domain: "No view controller available", code: -1)
            }
            
            let config = GIDConfiguration(clientID: "561478665315-amhpaq9hq281k1anmmhh1uiv099feu3f.apps.googleusercontent.com")
            GIDSignIn.sharedInstance.configuration = config
            
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            
            guard let idToken = result.user.idToken?.tokenString else {
                throw NSError(domain: "No ID token received", code: -1)
            }
            
            try await supabaseClient.auth.signInWithIdToken(
                credentials: .init(
                    provider: .google,
                    idToken: idToken
                )
            )
            
            authResult = .success(())
            
            appState.setAuthState(.authenticated)
            
        } catch {
            authResult = .failure(error)
        }
    }
    
    private func getRootViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }
    
    //MARK: - OTP Sign Up Methods
    
    func handleSignUpWithOTP() {
        guard isValid else {
            alertMessage = "Please enter your email and password"
            showAllert()
            return
        }
        Task {
            await signUpWithOTP(using: SupabaseClient.development)
        }
    }
    
    private func signUpWithOTP(using supabaseClient: SupabaseClient) async {
        toggleLoaidngState()
        defer {
            toggleLoaidngState()
        }
        
        do {
            try await supabaseClient.auth.signUp(
                email: userEmail,
                password: userPassword
            )
            
            // Store email and show OTP input
            pendingEmail = userEmail
            isAwaitingOTP = true
            alertMessage = "Check your email for the verification code"
            showAllert()
            
            
        } catch {
            authResult = .failure(error)
        }
    }
    
    func handleVerifyOTP() {
        guard !otpCode.isEmpty else {
            alertMessage = "Please enter the verification code"
            showAllert()
            return
        }
        Task {
            await verifyOTP(using: SupabaseClient.development)
        }
        
    }
    
    private func verifyOTP(using supabaseClient: SupabaseClient) async {
        toggleLoaidngState()
        defer {
            toggleLoaidngState()
            
        }
        
        do {

            try await supabaseClient.auth.verifyOTP(
                email: pendingEmail,
                token: otpCode,
                type: .signup
            )
            
            authResult = .success(())
            isAwaitingOTP = false
            showSignUp = false
            
            
        } catch {
            if let authError = error as? AuthError {
                if case .api(let apiError) = authError, apiError.errorCode.rawValue == "otp_expired" {
                    alertMessage = "Code expired. Please request a new one."
                } else {
                    alertMessage = "Invalid code. Please try again."
                }
            } else {
                alertMessage = error.localizedDescription
            }
            authResult = .failure(error)
        }
    }
    func resetAuthState() {
        isAwaitingOTP = false
        otpCode = ""
        pendingEmail = ""
        userEmail = ""
        userPassword = ""
    }
}
