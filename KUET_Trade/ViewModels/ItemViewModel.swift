//
//  ItemViewModel.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import Foundation
import SwiftUI

@MainActor
class ItemViewModel: ObservableObject {
    
    // MARK: - Items
    @Published var allItems: [Item] = []
    @Published var filteredItems: [Item] = []
    
    // MARK: - Filters
    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }
    @Published var selectedCategory: ItemCategory? = nil {
        didSet { applyFilters() }
    }
    @Published var selectedSort: SortOption = .newest {
        didSet { applyFilters() }
    }
    @Published var minPrice: String = "" {
        didSet { applyFilters() }
    }
    @Published var maxPrice: String = "" {
        didSet { applyFilters() }
    }
    
    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Init
    init() {
        Task {
            await loadItems()
        }
    }
    
    // MARK: - Load All Items
    func loadItems() async {
        isLoading = allItems.isEmpty
        do {
            let items = try await FirestoreService.shared.fetchAllItems()
            allItems = items
            applyFilters()
        } catch {
            errorMessage = "Failed to load items: \(error.localizedDescription)"
            showError = true
        }
        isLoading = false
        isRefreshing = false
    }
    
    // MARK: - Refresh
    func refresh() async {
        isRefreshing = true
        await loadItems()
    }
    
    // MARK: - Apply Filters & Sort
    func applyFilters() {
        var result = allItems
        
        // Category filter
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }
        
        // Search filter — token-based for better matching
        if !searchText.trimmed.isEmpty {
            let query = searchText.trimmed.lowercased()
            let tokens = query.split(separator: " ").map(String.init)
            result = result.filter { item in
                let searchableText = "\(item.title) \(item.description) \(item.sellerName) \(item.category.rawValue)".lowercased()
                // Match if ALL tokens appear somewhere in the searchable text
                return tokens.allSatisfy { token in
                    searchableText.contains(token)
                }
            }
        }
        
        // Price range filter
        if let min = Double(minPrice.trimmed), min > 0 {
            result = result.filter { $0.price >= min }
        }
        if let max = Double(maxPrice.trimmed), max > 0 {
            result = result.filter { $0.price <= max }
        }
        
        // Sort
        switch selectedSort {
        case .newest:
            result.sort { $0.createdAt > $1.createdAt }
        case .oldest:
            result.sort { $0.createdAt < $1.createdAt }
        case .priceLowToHigh:
            result.sort { $0.price < $1.price }
        case .priceHighToLow:
            result.sort { $0.price > $1.price }
        }
        
        filteredItems = result
    }
    
    // MARK: - Clear Filters
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        selectedSort = .newest
        minPrice = ""
        maxPrice = ""
    }
    
    // MARK: - Computed
    var hasActiveFilters: Bool {
        selectedCategory != nil || !searchText.isEmpty || selectedSort != .newest || !minPrice.isEmpty || !maxPrice.isEmpty
    }
    
    var activeFilterCount: Int {
        var count = 0
        if selectedCategory != nil { count += 1 }
        if !searchText.trimmed.isEmpty { count += 1 }
        if selectedSort != .newest { count += 1 }
        if !minPrice.trimmed.isEmpty || !maxPrice.trimmed.isEmpty { count += 1 }
        return count
    }
    
    var itemCount: Int {
        filteredItems.count
    }
    
    var isEmpty: Bool {
        filteredItems.isEmpty && !isLoading
    }
    
    // MARK: - Price Range Display
    var priceRangeDescription: String? {
        let min = Double(minPrice.trimmed)
        let max = Double(maxPrice.trimmed)
        
        if let min = min, let max = max, min > 0, max > 0 {
            return "৳\(String(format: "%.0f", min)) – ৳\(String(format: "%.0f", max))"
        } else if let min = min, min > 0 {
            return "৳\(String(format: "%.0f", min))+"
        } else if let max = max, max > 0 {
            return "Up to ৳\(String(format: "%.0f", max))"
        }
        return nil
    }
}
