//
//  Item.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import Foundation
import FirebaseFirestore

// MARK: - Item Category Enum
enum ItemCategory: String, Codable, CaseIterable, Identifiable {
    case books = "Books"
    case electronics = "Electronics"
    case accessories = "Accessories"
    case others = "Others"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .books: return "book.fill"
        case .electronics: return "laptopcomputer"
        case .accessories: return "headphones"
        case .others: return "shippingbox.fill"
        }
    }
    
    var color: String {
        switch self {
        case .books: return "blue"
        case .electronics: return "purple"
        case .accessories: return "orange"
        case .others: return "green"
        }
    }
}

// MARK: - Sort Option Enum
enum SortOption: String, CaseIterable, Identifiable {
    case newest = "Newest First"
    case oldest = "Oldest First"
    case priceLowToHigh = "Price: Low to High"
    case priceHighToLow = "Price: High to Low"
    
    var id: String { rawValue }
}

// MARK: - Item Model
struct Item: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var description: String
    var price: Double
    var category: ItemCategory
    var imageURLs: [String]
    var sellerID: String
    var sellerName: String
    var sellerPhone: String
    var isAvailable: Bool
    var createdAt: Date
    var updatedAt: Date
    
    // Formatted price string
    var formattedPrice: String {
        return "৳\(String(format: "%.0f", price))"
    }
    
    // Time ago string
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
    
    // Default initializer
    init(
        id: String? = nil,
        title: String,
        description: String,
        price: Double,
        category: ItemCategory,
        imageURLs: [String] = [],
        sellerID: String,
        sellerName: String,
        sellerPhone: String,
        isAvailable: Bool = true,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.category = category
        self.imageURLs = imageURLs
        self.sellerID = sellerID
        self.sellerName = sellerName
        self.sellerPhone = sellerPhone
        self.isAvailable = isAvailable
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
