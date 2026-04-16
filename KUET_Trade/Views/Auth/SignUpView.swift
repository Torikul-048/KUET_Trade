//
//  SignUpView.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    private let batchOptions = ["18", "19", "20", "21", "22", "23", "24", "25", "26"]
    
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

                    // Roll Number
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Roll Number", systemImage: "number")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        TextField("e.g. 2007001", text: $viewModel.signupRoll)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                    }

                    // Batch Picker
                    VStack(alignment: .leading, spacing: 6) {
                        Label("Batch", systemImage: "calendar")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Menu {
                            ForEach(batchOptions, id: \.self) { batch in
                                Button("Batch '\(batch)") {
                                    viewModel.signupBatch = batch
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.signupBatch.isEmpty ? "Select your batch" : "Batch '\(viewModel.signupBatch)")
                                    .foregroundStyle(viewModel.signupBatch.isEmpty ? Color(.placeholderText) : .primary)
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

                    // Reference Friend
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Enter details of a KUET friend who can vouch for you")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            VStack(alignment: .leading, spacing: 6) {
                                Label("Friend Name", systemImage: "person.2.fill")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                TextField("Friend's full name", text: $viewModel.refFriendName)
                                    .textFieldStyle(.roundedBorder)
                                    .autocorrectionDisabled()
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Label("Friend Roll", systemImage: "number")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                TextField("e.g. 1907002", text: $viewModel.refFriendRoll)
                                    .textFieldStyle(.roundedBorder)
                                    .keyboardType(.numberPad)
                            }

                            VStack(alignment: .leading, spacing: 6) {
                                Label("Friend Department", systemImage: "building.columns")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Menu {
                                    ForEach(AppConstants.departments, id: \.self) { dept in
                                        Button(dept) {
                                            viewModel.refFriendDept = dept
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(viewModel.refFriendDept.isEmpty ? "Select friend's department" : viewModel.refFriendDept)
                                            .foregroundStyle(viewModel.refFriendDept.isEmpty ? Color(.placeholderText) : .primary)
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

                            VStack(alignment: .leading, spacing: 6) {
                                Label("Friend Batch", systemImage: "calendar")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)

                                Menu {
                                    ForEach(batchOptions, id: \.self) { batch in
                                        Button("Batch '\(batch)") {
                                            viewModel.refFriendBatch = batch
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(viewModel.refFriendBatch.isEmpty ? "Select friend's batch" : "Batch '\(viewModel.refFriendBatch)")
                                            .foregroundStyle(viewModel.refFriendBatch.isEmpty ? Color(.placeholderText) : .primary)
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
                        }
                        .padding(.top, 4)
                    } label: {
                        Label("KUETian Reference", systemImage: "person.2.badge.gearshape")
                            .font(.subheadline)
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
