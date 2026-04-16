//
//  ReviewViewModel.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation

@MainActor
final class ReviewViewModel: ObservableObject {
    @Published var reviews: [Review] = []
    @Published var averageRating: Double = 0
    @Published var totalReviews: Int = 0

    @Published var selectedRating: Int = 0
    @Published var comment: String = ""
    @Published var isVerifiedPurchase: Bool = false

    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var didSubmit = false

    func loadReviews(sellerId: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            let loaded = try await ReviewService.shared.fetchReviews(for: sellerId)
            reviews = loaded
            totalReviews = loaded.count
            averageRating = loaded.isEmpty ? 0 : loaded.reduce(0, { $0 + $1.rating }) / Double(loaded.count)
        } catch {
            showErrorMessage("Failed to load reviews: \(error.localizedDescription)")
        }
    }

    func submitReview(item: Item, reviewer: KTUser) async {
        guard reviewer.uid != item.sellerID else {
            showErrorMessage("You cannot review your own listing.")
            return
        }

        guard selectedRating > 0 else {
            showErrorMessage("Please select a star rating.")
            return
        }

        let trimmedComment = comment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedComment.isEmpty else {
            showErrorMessage("Please write a short review.")
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            if let itemId = item.id {
                let alreadyReviewed = try await ReviewService.shared.hasUserReviewedItem(reviewerId: reviewer.uid, itemId: itemId)
                if alreadyReviewed {
                    showErrorMessage("You already reviewed this item.")
                    return
                }
            }

            let review = Review(
                reviewerId: reviewer.uid,
                reviewerName: reviewer.name,
                sellerId: item.sellerID,
                itemId: item.id,
                rating: Double(selectedRating),
                comment: trimmedComment,
                isVerifiedPurchase: isVerifiedPurchase
            )

            try await ReviewService.shared.createReview(review)
            didSubmit = true
            clearComposer()
            await loadReviews(sellerId: item.sellerID)
        } catch {
            showErrorMessage("Failed to submit review: \(error.localizedDescription)")
        }
    }

    func clearComposer() {
        selectedRating = 0
        comment = ""
        isVerifiedPurchase = false
        didSubmit = false
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}
