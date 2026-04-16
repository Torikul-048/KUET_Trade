//
//  Review.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseFirestore

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var reviewerId: String
    var reviewerName: String
    var sellerId: String
    var itemId: String?
    var rating: Double
    var comment: String
    var createdAt: Date
    var isVerifiedPurchase: Bool

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: createdAt)
    }

    init(
        id: String? = nil,
        reviewerId: String,
        reviewerName: String,
        sellerId: String,
        itemId: String? = nil,
        rating: Double,
        comment: String,
        createdAt: Date = Date(),
        isVerifiedPurchase: Bool = false
    ) {
        self.id = id
        self.reviewerId = reviewerId
        self.reviewerName = reviewerName
        self.sellerId = sellerId
        self.itemId = itemId
        self.rating = rating
        self.comment = comment
        self.createdAt = createdAt
        self.isVerifiedPurchase = isVerifiedPurchase
    }
}
