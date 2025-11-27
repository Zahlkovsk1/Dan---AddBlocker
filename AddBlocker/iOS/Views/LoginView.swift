//
//  LoginView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct LoginView: View {
    @Environment(AppState.self) private var appState
    @State var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
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
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 60)
                        
                        ShieldAnimationView()
                            .padding(.bottom, 40)
                        
                        VStack(spacing: 12) {
                            Text("Set Up Account to Save")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Your Progress")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 16)
                        
                        Text("Sign in or register to use AdBlocker")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 40)
                    
                        TextField("", text: $viewModel.userEmail, prompt: Text("Email").foregroundColor(.white.opacity(0.5)))
                            .keyboardType(.emailAddress)
                            .textContentType(.username)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 12)
                        
                        SecureField("", text: $viewModel.userPassword, prompt: Text("Password").foregroundColor(.white.opacity(0.5)))
                            .textContentType(.password)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                        
                        // Email login button
                        Button(action: {
                            viewModel.handleSingInButtonTapped()
                        }) {
                            Text("Sign in")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                        .disabled(viewModel.isLoading || !viewModel.isValid)
                        .opacity((viewModel.isLoading || !viewModel.isValid) ? 0.5 : 1)
                    
                        HStack {
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Text("continue with")
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 12)
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                        
                        // Social login buttons
                        Button(action: {
                            viewModel.handleAppleSignIn()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 20, weight: .regular))
                                Text("Sign in with Apple")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 12)
                        
                        Button(action: {
                            viewModel.handleGoogleSignInButtonTapped()
                        }) {
                            HStack(spacing: 10) {
                                Image("google-icon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                Text("Sign in with Google")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                  
                        // Register button
                        Button(action: {
                            viewModel.showSignUp = true
                        }) {
                            HStack(spacing: 4) {
                                Text("Don't have an account?")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.white.opacity(0.6))
                                Text("Register")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 8)
                        
                        Spacer()
                            .frame(height: 60)
                    }
                }
                
                if viewModel.isLoading {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.2)
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $viewModel.showSignUp) {
                SignUpView(viewModel: viewModel)
            }
            .alert("Login Failed", isPresented: $viewModel.isShowingAllert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

struct SignUpView: View {
    @Bindable var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
            
            if viewModel.isAwaitingOTP {
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 80)
                        
                        Image(systemName: "envelope.badge.shield.half.filled")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                        
                        Text("Verify Your Email")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.bottom, 12)
                        
                        Text("Enter the 6-digit code sent to")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(viewModel.pendingEmail)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.bottom, 40)
                        
                        TextField("", text: $viewModel.otpCode, prompt: Text("000000").foregroundColor(.white.opacity(0.5)))
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            .multilineTextAlignment(.center)
                            .font(.system(size: 32, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 30)
                        
                        Button(action: {
                            viewModel.handleVerifyOTP()
                        }) {
                            Text("Verify")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                )
                        }
                        .padding(.horizontal, 24)
                        .disabled(viewModel.otpCode.count != 6)
                        .opacity(viewModel.otpCode.count != 6 ? 0.5 : 1)
                        
                        Spacer()
                    }
                }
                
            } else {

                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 80)
                        
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                            .padding(.bottom, 30)
                        
                        VStack(spacing: 12) {
                            Text("Create Account")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 16)
                        
                        Text("Sign up to start using YBlock")
                            .font(.system(size: 15, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 40)
                        
                        TextField("", text: $viewModel.userEmail, prompt: Text("Email").foregroundColor(.white.opacity(0.5)))
                            .keyboardType(.emailAddress)
                            .textContentType(.username)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 12)
                        
                        SecureField("", text: $viewModel.userPassword, prompt: Text("Password").foregroundColor(.white.opacity(0.5)))
                            .textContentType(.newPassword)
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                        
                        Button(action: {
                            viewModel.handleSignUpWithOTP()
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)
                        .disabled(!viewModel.isValid)
                        .opacity(!viewModel.isValid ? 0.5 : 1)
                        
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Text("Already have an account?")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.white.opacity(0.6))
                                Text("Sign In")
                                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.top, 8)
                        
                        Spacer()
                            .frame(height: 60)
                    }
                }
            }
            
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.2)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .tint(.white)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.isAwaitingOTP ? "Verification" : "Register")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color(white: 0.08).opacity(0.95), for: .navigationBar)
        .alert("Verification", isPresented: $viewModel.isShowingAllert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}


extension AuthViewModel: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func handleAppleSignIn() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            handleAppleSignInCompletion(result: .success(authorization))
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        handleAppleSignInCompletion(result: .failure(error))
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? UIWindow()
    }
}

