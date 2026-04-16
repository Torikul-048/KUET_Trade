//
//  BuyRequestViewModel.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation

@MainActor
final class BuyRequestViewModel: ObservableObject {
    @Published var requests: [BuyRequest] = []

    @Published var title: String = ""
    @Published var description: String = ""
    @Published var selectedCategory: ItemCategory = .others
    @Published var maxBudgetText: String = ""

    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var didPostSuccessfully = false

    var maxBudget: Double {
        Double(maxBudgetText) ?? 0
    }

    func loadRequests() async {
        isLoading = true
        defer { isLoading = false }

        do {
            requests = try await BuyRequestService.shared.fetchAllActiveRequests()
        } catch {
            let msg = error.localizedDescription.lowercased()
            if msg.contains("permission") || msg.contains("insufficient") || msg.contains("missing") {
                showError("Failed to load buy requests: Missing or insufficient permissions. Publish Firestore rules for /buyRequests and ensure you are logged in.")
            } else {
                showError("Failed to load buy requests: \(error.localizedDescription)")
            }
        }
    }

    func postRequest(currentUser: KTUser) async {
        guard validate() else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let request = BuyRequest(
                title: title.trimmed,
                description: description.trimmed,
                category: selectedCategory,
                maxBudget: maxBudget,
                buyerId: currentUser.uid,
                buyerName: currentUser.name,
                buyerPhone: currentUser.phone
            )

            _ = try await BuyRequestService.shared.createBuyRequest(request)
            clearForm()
            didPostSuccessfully = true
            await loadRequests()
        } catch {
            showError("Failed to post buy request: \(error.localizedDescription)")
        }
    }

    func deactivate(_ request: BuyRequest) async {
        guard let id = request.id else { return }

        do {
            try await BuyRequestService.shared.deactivateRequest(id: id)
            await loadRequests()
        } catch {
            showError("Failed to update request: \(error.localizedDescription)")
        }
    }

    func clearForm() {
        title = ""
        description = ""
        selectedCategory = .others
        maxBudgetText = ""
        didPostSuccessfully = false
    }

    private func validate() -> Bool {
        if title.trimmed.isEmpty {
            showError("Please enter a title.")
            return false
        }
        if description.trimmed.isEmpty {
            showError("Please enter a description.")
            return false
        }
        if maxBudget <= 0 {
            showError("Please enter a valid budget.")
            return false
        }
        return true
    }

    private func showError(_ message: String) {
        errorMessage = message
        showError = true
    }
}
