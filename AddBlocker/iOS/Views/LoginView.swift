//
//  LoginView.swift
//  AddBlocker
//
//  Created by Gabons on 12/11/25.
//

import SwiftUI
import GoogleSignInSwift

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
                        
                        Text("Sign in or register to use AdBlocker\non multiple devices")
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
                        
                        Button(action: {
                            // TODO: Apple Sign In
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 18))
                                Text("Sign in with Apple")
                                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.white)
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
                        .padding(.bottom, 12)
                        
                     
                        Button(action: {
                            viewModel.handleSingInButtonTapped()
                        }) {
                            Text("Sign in with Email")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
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
                        .disabled(viewModel.isLoading || !viewModel.isValid)
                        .opacity((viewModel.isLoading || !viewModel.isValid) ? 0.5 : 1)
                  
                        Button(action: {
                            viewModel.showSignUp = true
                        }) {
                            Text("Register")
                                .font(.system(size: 16, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 12)
                        
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
    var body: some View {
        VStack {
            if viewModel.isAwaitingOTP {
                VStack(spacing: 20) {
                    Text("Verify Your Email")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Enter the 6-digit code sent to\n\(viewModel.pendingEmail)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    TextField("Enter OTP Code", text: $viewModel.otpCode)
                        .keyboardType(.numberPad)
                        .textContentType(.oneTimeCode)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 24, weight: .medium))
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.handleVerifyOTP()
   
                    }) {
                        Text("Verify")
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .disabled(viewModel.otpCode.count != 6)
                }
                .padding()
                
            } else {
                // Sign Up Form
                TextField("Email", text: $viewModel.userEmail)
                    .keyboardType(.emailAddress)
                    .textContentType(.username)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                
                SecureField("Password", text: $viewModel.userPassword)
                    .textContentType(.newPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                
                Spacer()
                
                Button(action: {
                    viewModel.handleSignUpWithOTP()
                }) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 12)
                .disabled(!viewModel.isValid)
            }
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.large)
        .alert("Verification", isPresented: $viewModel.isShowingAllert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
        
    }
}
