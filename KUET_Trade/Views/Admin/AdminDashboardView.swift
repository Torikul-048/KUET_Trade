//
//  AdminDashboardView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct AdminDashboardView: View {
    @ObservedObject var viewModel: AdminViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: PendingUsersView(viewModel: viewModel)) {
                        Label("Review Pending Users", systemImage: "clock.badge.questionmark")
                    }
                } header: {
                    Label("Pending Approvals (\(viewModel.pendingUsers.count))", systemImage: "clock.badge.questionmark")
                }

                Section {
                    NavigationLink(destination: AllUsersView(viewModel: viewModel)) {
                        Label("Manage All Users", systemImage: "person.3.fill")
                    }
                } header: {
                    Label("User Management", systemImage: "person.crop.circle.badge.checkmark")
                }

                Section {
                    LabeledContent("Total Users", value: "\(viewModel.totalUsers)")
                    LabeledContent("Verified", value: "\(viewModel.verifiedUsers)")
                    LabeledContent("Pending", value: "\(viewModel.pendingUsers.count)")
                    LabeledContent("Rejected", value: "\(viewModel.rejectedUsers)")
                } header: {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
            }
            .navigationTitle("Admin Panel")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Logout") {
                        viewModel.adminSignOut()
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
            }
            .refreshable {
                await viewModel.fetchAllData()
            }
            .task {
                await viewModel.fetchAllData()
            }
        }
    }
}

#Preview {
    AdminDashboardView(viewModel: AdminViewModel())
}
