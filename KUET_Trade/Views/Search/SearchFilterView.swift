//
//  SearchFilterView.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

struct SearchFilterView: View {
    @ObservedObject var itemViewModel: ItemViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Search Section
                Section {
                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        
                        TextField("Search by title, seller, etc.", text: $itemViewModel.searchText)
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
                    }
                } header: {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
                // MARK: - Category Section
                Section {
                    // All option
                    Button {
                        itemViewModel.selectedCategory = nil
                    } label: {
                        HStack {
                            Image(systemName: "square.grid.2x2.fill")
                                .foregroundStyle(Color.accentColor)
                                .frame(width: 24)
                            Text("All Categories")
                                .foregroundStyle(.primary)
                            Spacer()
                            if itemViewModel.selectedCategory == nil {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.accentColor)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    
                    ForEach(ItemCategory.allCases) { category in
                        Button {
                            itemViewModel.selectedCategory = category
                        } label: {
                            HStack {
                                Image(systemName: category.icon)
                                    .foregroundStyle(categoryColor(category))
                                    .frame(width: 24)
                                Text(category.rawValue)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if itemViewModel.selectedCategory == category {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accentColor)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                } header: {
                    Label("Category", systemImage: "tag.fill")
                }
                
                // MARK: - Price Range Section
                Section {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Min (৳)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("0", text: $itemViewModel.minPrice)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                        }
                        
                        Text("–")
                            .foregroundStyle(.secondary)
                            .padding(.top, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Max (৳)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            TextField("Any", text: $itemViewModel.maxPrice)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    
                    // Quick price presets
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            PricePresetChip(label: "Under ৳200", isSelected: itemViewModel.minPrice == "" && itemViewModel.maxPrice == "200") {
                                itemViewModel.minPrice = ""
                                itemViewModel.maxPrice = "200"
                            }
                            PricePresetChip(label: "৳200–৳500", isSelected: itemViewModel.minPrice == "200" && itemViewModel.maxPrice == "500") {
                                itemViewModel.minPrice = "200"
                                itemViewModel.maxPrice = "500"
                            }
                            PricePresetChip(label: "৳500–৳1000", isSelected: itemViewModel.minPrice == "500" && itemViewModel.maxPrice == "1000") {
                                itemViewModel.minPrice = "500"
                                itemViewModel.maxPrice = "1000"
                            }
                            PricePresetChip(label: "৳1000+", isSelected: itemViewModel.minPrice == "1000" && itemViewModel.maxPrice == "") {
                                itemViewModel.minPrice = "1000"
                                itemViewModel.maxPrice = ""
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    
                    if itemViewModel.priceRangeDescription != nil {
                        HStack {
                            Text("Active range: \(itemViewModel.priceRangeDescription!)")
                                .font(.caption)
                                .foregroundStyle(Color.accentColor)
                            Spacer()
                            Button("Clear") {
                                itemViewModel.minPrice = ""
                                itemViewModel.maxPrice = ""
                            }
                            .font(.caption)
                            .foregroundStyle(.red)
                        }
                    }
                } header: {
                    Label("Price Range", systemImage: "bangladeshitakasign")
                }
                
                // MARK: - Sort Section
                Section {
                    ForEach(SortOption.allCases) { option in
                        Button {
                            itemViewModel.selectedSort = option
                        } label: {
                            HStack {
                                Text(option.rawValue)
                                    .foregroundStyle(.primary)
                                Spacer()
                                if itemViewModel.selectedSort == option {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(Color.accentColor)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                } header: {
                    Label("Sort By", systemImage: "arrow.up.arrow.down")
                }
                
                // MARK: - Results Preview
                Section {
                    HStack {
                        Image(systemName: "number")
                            .foregroundStyle(Color.accentColor)
                        Text("\(itemViewModel.itemCount) item\(itemViewModel.itemCount == 1 ? "" : "s") found")
                            .fontWeight(.medium)
                        Spacer()
                        if itemViewModel.hasActiveFilters {
                            Text("\(itemViewModel.activeFilterCount) filter\(itemViewModel.activeFilterCount == 1 ? "" : "s") active")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Label("Results", systemImage: "list.bullet")
                }
                
                // MARK: - Clear All
                if itemViewModel.hasActiveFilters {
                    Section {
                        Button(role: .destructive) {
                            itemViewModel.clearFilters()
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "xmark.circle.fill")
                                Text("Clear All Filters")
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search & Filter")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.kuetSurface)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
    
    // MARK: - Category Color Helper
    private func categoryColor(_ category: ItemCategory) -> Color {
        switch category {
        case .books: return Color.kuetGreen
        case .electronics: return .indigo
        case .accessories: return Color.kuetGold
        case .others: return .teal
        }
    }
}

// MARK: - Price Preset Chip
struct PricePresetChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.tertiarySystemGroupedBackground))
                .foregroundStyle(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

#Preview {
    SearchFilterView(itemViewModel: ItemViewModel())
}
