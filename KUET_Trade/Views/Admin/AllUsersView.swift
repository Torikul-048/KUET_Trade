//
//  AllUsersView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct AllUsersView: View {
    @ObservedObject var viewModel: AdminViewModel
    @State private var searchText = ""
    @State private var filterStatus: VerificationStatus? = nil

    private var filteredUsers: [KTUser] {
        var users = viewModel.allUsers

        if let status = filterStatus {
            users = users.filter { $0.verificationStatus == status }
        }

        if !searchText.isEmpty {
            users = users.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.email.localizedCaseInsensitiveContains(searchText)
                || $0.roll.contains(searchText)
            }
        }

        return users
    }

    var body: some View {
        List {
            Section {
                Picker("Filter by Status", selection: $filterStatus) {
                    Text("All Users").tag(nil as VerificationStatus?)
                    Text("Verified").tag(VerificationStatus.approved as VerificationStatus?)
                    Text("Pending").tag(VerificationStatus.pending as VerificationStatus?)
                    Text("Rejected").tag(VerificationStatus.rejected as VerificationStatus?)
                }
                .pickerStyle(.segmented)
            }

            Section("Users (\(filteredUsers.count))") {
                ForEach(filteredUsers) { user in
                    NavigationLink(destination: UserVerificationDetailView(user: user, viewModel: viewModel)) {
                        HStack {
                            Circle()
                                .fill(statusColor(for: user).opacity(0.2))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(user.initials)
                                        .font(.caption)
                                        .fontWeight(.bold)
                                )

                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .fontWeight(.medium)
                                Text(user.email)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Circle()
                                .fill(statusColor(for: user))
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search by name, email, or roll")
        .navigationTitle("All Users")
    }

    private func statusColor(for user: KTUser) -> Color {
        switch user.verificationStatus {
        case .pending: return .orange
        case .approved: return .green
        case .rejected: return .red
        }
    }
}

#Preview {
    AllUsersView(viewModel: AdminViewModel())
}
