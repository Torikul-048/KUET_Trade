//
//  LoginView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Logo & Header
                    VStack(spacing: 12) {
                        Image(systemName: "storefront.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(Color.accentColor)
                        
                        Text(AppConstants.appName)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text(AppConstants.appTagline)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 16)
                    
                    // MARK: - Login Form
                    VStack(spacing: 16) {
                        // Email
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Email", systemImage: "envelope.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            TextField("Enter your email", text: $viewModel.loginEmail)
                                .textFieldStyle(.roundedBorder)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                        }
                        
                        // Password
                        VStack(alignment: .leading, spacing: 6) {
                            Label("Password", systemImage: "lock.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            SecureField("Enter your password", text: $viewModel.loginPassword)
                                .textFieldStyle(.roundedBorder)
                                .textContentType(.password)
                        }
                        
                        // Forgot Password Link
                        HStack {
                            Spacer()
                            Button("Forgot Password?") {
                                showForgotPassword = true
                            }
                            .font(.subheadline)
                            .foregroundStyle(Color.accentColor)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Login Button
                    Button {
                        Task {
                            await viewModel.login()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text("Log In")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.horizontal)
                    
                    // MARK: - Divider
                    HStack {
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color(.separator))
                        Text("OR")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color(.separator))
                    }
                    .padding(.horizontal, 32)
                    
                    // MARK: - Sign Up Link
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundStyle(.secondary)
                        Button("Sign Up") {
                            showSignUp = true
                        }
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.accentColor)
                    }
                    .font(.subheadline)
                    
                    // MARK: - University Badge
                    Text(AppConstants.universityName)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 8)
                }
                .padding(.bottom, 32)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationDestination(isPresented: $showSignUp) {
                SignUpView(viewModel: viewModel)
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView(viewModel: viewModel)
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}
