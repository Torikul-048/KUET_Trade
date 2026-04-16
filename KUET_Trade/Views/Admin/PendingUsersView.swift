//
//  PendingUsersView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct PendingUsersView: View {
    @ObservedObject var viewModel: AdminViewModel

    var body: some View {
        List {
            if viewModel.pendingUsers.isEmpty {
                ContentUnavailableView(
                    "No Pending Users",
                    systemImage: "checkmark.seal",
                    description: Text("All users are already reviewed.")
                )
            } else {
                ForEach(viewModel.pendingUsers) { user in
                    NavigationLink(destination: UserVerificationDetailView(user: user, viewModel: viewModel)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .fontWeight(.medium)
                            Text("\(user.department) • Roll \(user.roll)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Pending Users")
        .refreshable {
            await viewModel.fetchAllData()
        }
    }
}

#Preview {
    NavigationStack {
        PendingUsersView(viewModel: AdminViewModel())
    }
}
