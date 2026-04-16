//
//  UserVerificationDetailView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct UserVerificationDetailView: View {
    let user: KTUser
    @ObservedObject var viewModel: AdminViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Circle()
                    .fill(Color.accentColor.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentColor)
                    )

                GroupBox(label: Label("User Information", systemImage: "person.fill")) {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(label: "Name", value: user.name)
                        InfoRow(label: "Email", value: user.email)
                        InfoRow(label: "Phone", value: user.phone)
                        InfoRow(label: "Department", value: user.department)
                        InfoRow(label: "Roll", value: user.roll)
                        InfoRow(label: "Batch", value: user.batch)
                    }
                }

                GroupBox(label: Label("KUETian Reference", systemImage: "person.2.fill")) {
                    VStack(alignment: .leading, spacing: 12) {
                        InfoRow(label: "Friend Name", value: user.refFriendName)
                        InfoRow(label: "Friend Roll", value: user.refFriendRoll)
                        InfoRow(label: "Friend Dept", value: user.refFriendDept)
                        InfoRow(label: "Friend Batch", value: user.refFriendBatch)
                    }
                }

                HStack {
                    Text("Status:")
                        .fontWeight(.medium)

                    Text(user.verificationStatus.rawValue.capitalized)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(statusColor.opacity(0.2))
                        .foregroundStyle(statusColor)
                        .cornerRadius(8)
                }

                VStack(spacing: 12) {
                    Button {
                        Task {
                            await viewModel.approveUser(user)
                            dismiss()
                        }
                    } label: {
                        Label("Approve User", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }

                    Button {
                        Task {
                            await viewModel.rejectUser(user)
                            dismiss()
                        }
                    } label: {
                        Label("Reject User", systemImage: "xmark.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }

                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete Account Permanently", systemImage: "trash.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Delete User Account", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete Permanently", role: .destructive) {
                Task {
                    await viewModel.deleteUser(user)
                    dismiss()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    private var statusColor: Color {
        switch user.verificationStatus {
        case .pending: return .orange
        case .approved: return .green
        case .rejected: return .red
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    UserVerificationDetailView(
        user: KTUser(
            uid: "preview",
            name: "Demo User",
            email: "demo@kuet.ac.bd",
            phone: "01700000000",
            department: "CSE",
            roll: "2007001",
            batch: "20",
            isVerified: false,
            verificationStatus: .pending,
            refFriendName: "Ref User",
            refFriendRoll: "1907002",
            refFriendDept: "EEE",
            refFriendBatch: "19"
        ),
        viewModel: AdminViewModel()
    )
}
