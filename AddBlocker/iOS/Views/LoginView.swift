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
                
                VStack(spacing: 0) {
                    Spacer()
                   // DNAHelixView()
                        .padding()
                    Spacer()
                    Text("Set Up Account to Save\nYour Progress")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                    
                    Text("Sign in or register to use your BioAge collections \n on multiple devices, and save your progress on cloud")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                    
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
                        .textContentType(.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    
                    Button(action: {
                        
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                            Text("Sign in with Apple")
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    
                    // Sign in with Google Button
                    Button(action: {
                        viewModel.handleGoogleSignInButtonTapped()
                    }) {
                        HStack {
                            Image("google-icon")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Sign in with Google")
                                .fontWeight(.semibold)
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5).opacity(0.3))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    
                    Button(action: {
                        viewModel.handleSingInButtonTapped()
                    }) {
                        Text("Sign-in with mail")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray5).opacity(0.3))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                    .disabled(viewModel.isLoading || !viewModel.isValid)
                    .alert("Login Failed", isPresented: $viewModel.isShowingAllert, actions: {
                        Button("OK", role: .cancel) {}
                    }, message: {
                        Text(viewModel.alertMessage)
                    })
                    
                    Button(action: {
                        viewModel.showSignUp = true  // Trigger navigation
                        // viewModel.handleSingUpButtonTapped()
                    }) {
                        Text("Register")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.clear)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .navigationBarHidden(true)
                .navigationDestination(isPresented: $viewModel.showSignUp) {
                    SignUpView(viewModel: viewModel)
                }
                
                if viewModel.isLoading {
                    ProgressView().opacity(0.7)
                }
                
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
