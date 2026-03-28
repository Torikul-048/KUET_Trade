//
//  SignUpView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: - Header
                VStack(spacing: 8) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 48))
                        .foregroundStyle(Color.accentColor)
                    
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Join the KUET marketplace")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 20)
                
                // MARK: - Signup Form
                VStack(spacing: 16) {
                    
                    // Full Name
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Full Name", systemImage: "person.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter your full name", text: $viewModel.signupName)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.name)
                            .autocorrectionDisabled()
                    }
                    
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Email", systemImage: "envelope.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextField("Enter your email", text: $viewModel.signupEmail)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                    
                    // Phone
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Phone Number", systemImage: "phone.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextField("e.g. 01XXXXXXXXX", text: $viewModel.signupPhone)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                    }
                    
                    // Department Picker
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Department", systemImage: "building.columns.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Menu {
                            ForEach(AppConstants.departments, id: \.self) { dept in
                                Button(dept) {
                                    viewModel.signupDepartment = dept
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.signupDepartment.isEmpty ? "Select your department" : viewModel.signupDepartment)
                                    .foregroundStyle(viewModel.signupDepartment.isEmpty ? Color(.placeholderText) : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(10)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.separator), lineWidth: 0.5)
                            )
                        }
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Password", systemImage: "lock.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        SecureField("At least 6 characters", text: $viewModel.signupPassword)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.newPassword)
                    }
                    
                    // Confirm Password
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Confirm Password", systemImage: "lock.rotation")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        SecureField("Re-enter your password", text: $viewModel.signupConfirmPassword)
                            .textFieldStyle(.roundedBorder)
                            .textContentType(.newPassword)
                    }
                    
                    // Password match indicator
                    if !viewModel.signupConfirmPassword.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: viewModel.signupPassword == viewModel.signupConfirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                            Text(viewModel.signupPassword == viewModel.signupConfirmPassword ? "Passwords match" : "Passwords do not match")
                        }
                        .font(.caption)
                        .foregroundStyle(viewModel.signupPassword == viewModel.signupConfirmPassword ? .green : .red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Sign Up Button
                Button {
                    Task {
                        await viewModel.signUp()
                    }
                } label: {
                    HStack(spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                        Text("Create Account")
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
                
                // MARK: - Login Link
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundStyle(.secondary)
                    Button("Log In") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accentColor)
                }
                .font(.subheadline)
                
                // MARK: - University Badge
                Text(AppConstants.universityName)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
                    .padding(.top, 4)
            }
            .padding(.bottom, 32)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            hideKeyboard()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView(viewModel: AuthViewModel())
    }
}
