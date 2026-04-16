//
//  ReviewService.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseFirestore

final class ReviewService {
    static let shared = ReviewService()

    private let db = Firestore.firestore()

    private init() {}

    private var reviewsCollection: CollectionReference {
        db.collection(AppConstants.Collections.reviews)
    }

    func fetchReviews(for sellerId: String) async throws -> [Review] {
        let snapshot = try await reviewsCollection
            .whereField("sellerId", isEqualTo: sellerId)
            .getDocuments()

        let reviews = snapshot.documents.compactMap { try? $0.data(as: Review.self) }
        return reviews.sorted { $0.createdAt > $1.createdAt }
    }

    func hasUserReviewedItem(reviewerId: String, itemId: String) async throws -> Bool {
        let snapshot = try await reviewsCollection
            .whereField("reviewerId", isEqualTo: reviewerId)
            .getDocuments()

        return snapshot.documents.contains { doc in
            (doc.data()["itemId"] as? String) == itemId
        }
    }

    func createReview(_ review: Review) async throws {
        _ = try reviewsCollection.addDocument(from: review)
        try await updateSellerReviewStats(sellerId: review.sellerId)
    }

    func fetchSellerStats(sellerId: String) async throws -> (average: Double, total: Int) {
        let reviews = try await fetchReviews(for: sellerId)
        guard !reviews.isEmpty else { return (0, 0) }

        let total = reviews.count
        let sum = reviews.reduce(0.0) { $0 + $1.rating }
        let average = sum / Double(total)
        return (average, total)
    }

    func updateSellerReviewStats(sellerId: String) async throws {
        let stats = try await fetchSellerStats(sellerId: sellerId)
        try await db.collection(AppConstants.Collections.users).document(sellerId).updateData([
            "averageRating": stats.average,
            "totalReviews": stats.total
        ])
    }
}
