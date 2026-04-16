//
//  ForgotPasswordView.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // MARK: - Header
                VStack(spacing: 12) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.accentColor)
                    
                    Text("Reset Password")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Enter your email and we'll send you\na link to reset your password.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 32)
                
                if viewModel.resetEmailSent {
                    // MARK: - Success State
                    VStack(spacing: 16) {
                        Image(systemName: "envelope.badge.shield.half.filled.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.green)
                        
                        Text("Check Your Email")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("We've sent a password reset link to\n**\(viewModel.resetEmail.trimmed)**")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Text("Didn't receive it? Check your spam folder or try again.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                        
                        Button {
                            viewModel.clearResetFields()
                            dismiss()
                        } label: {
                            Text("Back to Login")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.accentColor)
                                .foregroundStyle(.white)
                                .cornerRadius(12)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                } else {
                    // MARK: - Email Field
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Email", systemImage: "envelope.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter your registered email", text: $viewModel.resetEmail)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Send Reset Link Button
                    Button {
                        Task {
                            await viewModel.resetPassword()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .tint(.white)
                            }
                            Text("Send Reset Link")
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
                }
                
                Spacer()
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.clearResetFields()
                        dismiss()
                    }
                }
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
    ForgotPasswordView(viewModel: AuthViewModel())
}
