//
//  AdminLoginView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct AdminLoginView: View {
    @StateObject private var viewModel = AdminViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 60))
                        .foregroundStyle(.red)

                    Text("Admin Access")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Authorized personnel only")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)

                VStack(spacing: 16) {
                    TextField("Admin Email", text: $viewModel.adminEmail)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)

                    SecureField("Password", text: $viewModel.adminPassword)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.password)
                }
                .padding(.horizontal)

                Button {
                    Task {
                        await viewModel.adminSignIn()
                    }
                } label: {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                        Text("Access Dashboard")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .disabled(viewModel.isLoading)
                .padding(.horizontal)

                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Access denied")
            }
            .fullScreenCover(isPresented: $viewModel.isAdminLoggedIn) {
                AdminDashboardView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    AdminLoginView()
}
