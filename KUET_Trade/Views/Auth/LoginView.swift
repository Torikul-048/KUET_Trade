//
//  LoginView.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    @State private var logoTapCount = 0
    @State private var showAdminButton = false
    @State private var showAdminLogin = false
    @State private var resetTapWorkItem: DispatchWorkItem?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Logo & Header
                    VStack(spacing: 16) {
                        Image("logoo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color.kuetGreen.opacity(0.3), radius: 8, x: 0, y: 4)
                            .onTapGesture {
                                handleLogoTap()
                            }
                        
                        VStack(spacing: 6) {
                            Text(AppConstants.appName)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.kuetGreen)
                            
                            Text(AppConstants.appTagline)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 50)
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

                    if showAdminButton {
                        Divider()
                            .padding(.horizontal)

                        Button {
                            showAdminLogin = true
                        } label: {
                            HStack {
                                Image(systemName: "shield.lefthalf.filled")
                                Text("Admin Login")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundStyle(.red)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.red, lineWidth: 1)
                            )
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
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
            .sheet(isPresented: $showAdminLogin) {
                AdminLoginView()
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }

    private func handleLogoTap() {
        logoTapCount += 1

        resetTapWorkItem?.cancel()
        let work = DispatchWorkItem {
            logoTapCount = 0
        }
        resetTapWorkItem = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: work)

        if logoTapCount >= 5 {
            withAnimation(.spring()) {
                showAdminButton = true
            }
            logoTapCount = 0
            resetTapWorkItem?.cancel()
        }
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel())
}
