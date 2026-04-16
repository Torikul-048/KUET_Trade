//
//  AdminViewModel.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation

@MainActor
final class AdminViewModel: ObservableObject {
    @Published var adminEmail = ""
    @Published var adminPassword = ""

    @Published var isLoading = false
    @Published var isAdminLoggedIn = false
    @Published var showError = false
    @Published var errorMessage: String?

    @Published var pendingUsers: [KTUser] = []
    @Published var allUsers: [KTUser] = []

    var totalUsers: Int { allUsers.count }
    var verifiedUsers: Int { allUsers.filter { $0.verificationStatus == .approved }.count }
    var rejectedUsers: Int { allUsers.filter { $0.verificationStatus == .rejected }.count }

    func adminSignIn() async {
        guard !adminEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !adminPassword.isEmpty else {
            showErrorMessage("Please enter admin email and password.")
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await AdminService.shared.signIn(
                email: adminEmail.trimmingCharacters(in: .whitespacesAndNewlines),
                password: adminPassword
            )
            isAdminLoggedIn = true
            await fetchAllData()
        } catch {
            showErrorMessage(error.localizedDescription)
        }
    }

    func adminSignOut() {
        AdminService.shared.signOut()
        isAdminLoggedIn = false
        adminEmail = ""
        adminPassword = ""
        pendingUsers = []
        allUsers = []
    }

    func fetchAllData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let pending = AdminService.shared.fetchPendingUsers()
            async let all = AdminService.shared.fetchAllUsers()

            pendingUsers = try await pending
            allUsers = try await all
        } catch {
            showErrorMessage("Failed to fetch users: \(error.localizedDescription)")
        }
    }

    func approveUser(_ user: KTUser) async {
        do {
            try await AdminService.shared.approveUser(user)
            await fetchAllData()
        } catch {
            showErrorMessage("Failed to approve user: \(error.localizedDescription)")
        }
    }

    func rejectUser(_ user: KTUser) async {
        do {
            try await AdminService.shared.rejectUser(user)
            await fetchAllData()
        } catch {
            showErrorMessage("Failed to reject user: \(error.localizedDescription)")
        }
    }

    func deleteUser(_ user: KTUser) async {
        do {
            try await AdminService.shared.deleteUserData(user)
            await fetchAllData()
        } catch {
            showErrorMessage("Failed to delete user: \(error.localizedDescription)")
        }
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}
