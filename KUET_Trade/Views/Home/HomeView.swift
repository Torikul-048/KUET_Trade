//
//  HomeView.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var itemViewModel: ItemViewModel
    @State private var showFilterSheet = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // MARK: - Branded Header
                    HStack(spacing: 12) {
                        Image("logoo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 42, height: 42)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                        VStack(alignment: .leading, spacing: 2) {
                            Text("KUET")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.kuetGreen)
                            Text("Trade Marketplace")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Search Bar
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        
                        TextField("Search items...", text: $itemViewModel.searchText)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                        
                        if !itemViewModel.searchText.isEmpty {
                            Button {
                                itemViewModel.searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        // Filter button inline
                        Button {
                            showFilterSheet = true
                        } label: {
                            ZStack(alignment: .topTrailing) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.body)
                                    .foregroundStyle(itemViewModel.hasActiveFilters ? Color.accentColor : .secondary)
                                
                                if itemViewModel.activeFilterCount > 0 {
                                    Text("\(itemViewModel.activeFilterCount)")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.white)
                                        .frame(width: 14, height: 14)
                                        .background(Color.red)
                                        .clipShape(Circle())
                                        .offset(x: 6, y: -6)
                                }
                            }
                        }
                    }
                    .padding(10)
                    .background(Color.kuetSurface)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // MARK: - Active Filter Tags
                    if itemViewModel.hasActiveFilters {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                if let cat = itemViewModel.selectedCategory {
                                    FilterTag(label: cat.rawValue, icon: cat.icon) {
                                        itemViewModel.selectedCategory = nil
                                    }
                                }
                                if let priceRange = itemViewModel.priceRangeDescription {
                                    FilterTag(label: priceRange, icon: "bangladeshitakasign") {
                                        itemViewModel.minPrice = ""
                                        itemViewModel.maxPrice = ""
                                    }
                                }
                                if itemViewModel.selectedSort != .newest {
                                    FilterTag(label: itemViewModel.selectedSort.rawValue, icon: "arrow.up.arrow.down") {
                                        itemViewModel.selectedSort = .newest
                                    }
                                }
                                if !itemViewModel.searchText.trimmed.isEmpty {
                                    FilterTag(label: "\"\(itemViewModel.searchText.trimmed)\"", icon: "magnifyingglass") {
                                        itemViewModel.searchText = ""
                                    }
                                }
                                
                                // Clear all
                                Button {
                                    itemViewModel.clearFilters()
                                } label: {
                                    Text("Clear All")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.red)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(Color.red.opacity(0.1))
                                        .cornerRadius(14)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // MARK: - Category Filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            // "All" chip
                            CategoryChip(
                                title: "All",
                                icon: "square.grid.2x2.fill",
                                isSelected: itemViewModel.selectedCategory == nil
                            ) {
                                itemViewModel.selectedCategory = nil
                            }
                            
                            ForEach(ItemCategory.allCases) { category in
                                CategoryChip(
                                    title: category.rawValue,
                                    icon: category.icon,
                                    isSelected: itemViewModel.selectedCategory == category
                                ) {
                                    itemViewModel.selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Sort & Count Bar
                    HStack {
                        Text("\(itemViewModel.itemCount) item\(itemViewModel.itemCount == 1 ? "" : "s")")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Menu {
                            ForEach(SortOption.allCases) { option in
                                Button {
                                    itemViewModel.selectedSort = option
                                } label: {
                                    HStack {
                                        Text(option.rawValue)
                                        if itemViewModel.selectedSort == option {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.arrow.down")
                                Text(itemViewModel.selectedSort.rawValue)
                            }
                            .font(.subheadline)
                            .foregroundStyle(Color.accentColor)
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Content
                    if itemViewModel.isLoading {
                        // Shimmer Skeleton Loading State
                        SkeletonGridView()
                            .padding(.top, 4)
                    } else if itemViewModel.isEmpty {
                        // Empty State
                        VStack(spacing: 12) {
                            Image(systemName: itemViewModel.hasActiveFilters ? "magnifyingglass" : "shippingbox")
                                .font(.system(size: 48))
                                .foregroundStyle(.secondary)
                            
                            Text(itemViewModel.hasActiveFilters ? "No items found" : "No items yet")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text(itemViewModel.hasActiveFilters
                                 ? "Try changing your search or filters."
                                 : "Be the first to post something!")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            
                            if itemViewModel.hasActiveFilters {
                                Button("Clear Filters") {
                                    itemViewModel.clearFilters()
                                }
                                .buttonStyle(.borderedProminent)
                                .padding(.top, 4)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        // Items Grid
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(itemViewModel.filteredItems) { item in
                                NavigationLink(destination: ItemDetailView(item: item)) {
                                    ItemCardView(item: item)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
            .refreshable {
                await itemViewModel.refresh()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .symbolVariant(itemViewModel.hasActiveFilters ? .fill : .none)
                    }
                }
            }
            .sheet(isPresented: $showFilterSheet) {
                SearchFilterView(itemViewModel: itemViewModel)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .alert("Error", isPresented: $itemViewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(itemViewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }
}

// MARK: - Filter Tag (dismissible chip)
struct FilterTag: View {
    let label: String
    let icon: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10))
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 8, weight: .bold))
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.accentColor.opacity(0.12))
        .foregroundStyle(Color.accentColor)
        .cornerRadius(14)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color(.secondarySystemGroupedBackground))
            .foregroundStyle(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

#Preview {
    HomeView(itemViewModel: ItemViewModel())
}
