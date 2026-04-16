//
//  BuyRequest.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseFirestore

struct BuyRequest: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var category: ItemCategory
    var maxBudget: Double
    var buyerId: String
    var buyerName: String
    var buyerPhone: String
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date

    var formattedBudget: String {
        "Budget: ৳\(String(format: "%.0f", maxBudget))"
    }

    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }

    init(
        id: String? = nil,
        title: String,
        description: String,
        category: ItemCategory,
        maxBudget: Double,
        buyerId: String,
        buyerName: String,
        buyerPhone: String,
        isActive: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.maxBudget = maxBudget
        self.buyerId = buyerId
        self.buyerName = buyerName
        self.buyerPhone = buyerPhone
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
