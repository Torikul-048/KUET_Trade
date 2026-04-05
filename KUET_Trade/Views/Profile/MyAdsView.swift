//
//  MyAdsView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

struct MyAdsView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @ObservedObject var itemViewModel: ItemViewModel
    
    @State private var myItems: [Item] = []
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    @State private var showError: Bool = false
    @State private var editingItem: Item? = nil
    @State private var showDeleteConfirm: Bool = false
    @State private var itemToDelete: Item? = nil
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    loadingView
                } else if myItems.isEmpty {
                    emptyView
                } else {
                    itemListView
                }
            }
            .navigationTitle("My Ads")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !myItems.isEmpty {
                        Text("\(myItems.count) ad\(myItems.count == 1 ? "" : "s")")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .refreshable {
                await loadMyItems()
            }
            .task {
                await loadMyItems()
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "An unknown error occurred.")
            }
            .alert("Delete Item", isPresented: $showDeleteConfirm) {
                Button("Cancel", role: .cancel) {
                    itemToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let item = itemToDelete {
                        Task { await deleteItem(item) }
                    }
                }
            } message: {
                Text("Are you sure you want to delete \"\(itemToDelete?.title ?? "this item")\"? This action cannot be undone.")
            }
            .sheet(item: $editingItem) { item in
                NavigationStack {
                    EditItemView(item: item) {
                        Task {
                            await loadMyItems()
                            await itemViewModel.refresh()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 12) {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading your ads...")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Empty View
    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "rectangle.stack.badge.plus")
                .font(.system(size: 52))
                .foregroundStyle(.secondary)
            
            Text("No Ads Yet")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Items you post will appear here.\nGo to the Post tab to create your first listing!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Item List
    private var itemListView: some View {
        List {
            // Summary section
            Section {
                HStack(spacing: 16) {
                    StatBadge(
                        count: myItems.filter { $0.isAvailable }.count,
                        label: "Active",
                        color: .green
                    )
                    StatBadge(
                        count: myItems.filter { !$0.isAvailable }.count,
                        label: "Sold",
                        color: .orange
                    )
                    StatBadge(
                        count: myItems.count,
                        label: "Total",
                        color: .accentColor
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
            }
            
            // Active items
            let activeItems = myItems.filter { $0.isAvailable }
            if !activeItems.isEmpty {
                Section("Active (\(activeItems.count))") {
                    ForEach(activeItems) { item in
                        MyAdRow(item: item)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    itemToDelete = item
                                    showDeleteConfirm = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    editingItem = item
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    Task { await toggleSold(item) }
                                } label: {
                                    Label("Mark Sold", systemImage: "checkmark.circle")
                                }
                                .tint(.orange)
                            }
                    }
                }
            }
            
            // Sold items
            let soldItems = myItems.filter { !$0.isAvailable }
            if !soldItems.isEmpty {
                Section("Sold (\(soldItems.count))") {
                    ForEach(soldItems) { item in
                        MyAdRow(item: item)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    itemToDelete = item
                                    showDeleteConfirm = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    Task { await toggleSold(item) }
                                } label: {
                                    Label("Relist", systemImage: "arrow.uturn.left.circle")
                                }
                                .tint(.green)
                            }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    // MARK: - Load My Items
    private func loadMyItems() async {
        guard let uid = authViewModel.currentUser?.uid else {
            isLoading = false
            return
        }
        
        do {
            let items = try await FirestoreService.shared.fetchUserItems(userID: uid)
            myItems = items
        } catch {
            errorMessage = "Failed to load your ads: \(error.localizedDescription)"
            showError = true
        }
        isLoading = false
    }
    
    // MARK: - Toggle Sold
    private func toggleSold(_ item: Item) async {
        guard let id = item.id else { return }
        
        do {
            try await FirestoreService.shared.toggleAvailability(
                itemID: id,
                isAvailable: !item.isAvailable
            )
            await loadMyItems()
            await itemViewModel.refresh()
        } catch {
            errorMessage = "Failed to update status: \(error.localizedDescription)"
            showError = true
        }
    }
    
    // MARK: - Delete Item
    private func deleteItem(_ item: Item) async {
        guard let id = item.id else { return }
        
        do {
            // Delete images from storage
            if !item.imageURLs.isEmpty {
                try? await StorageService.shared.deleteImages(urls: item.imageURLs)
            }
            
            // Delete Firestore document
            try await FirestoreService.shared.deleteItem(byID: id)
            
            await loadMyItems()
            await itemViewModel.refresh()
        } catch {
            errorMessage = "Failed to delete item: \(error.localizedDescription)"
            showError = true
        }
        
        itemToDelete = nil
    }
}

// MARK: - My Ad Row
struct MyAdRow: View {
    let item: Item
    
    var body: some View {
        HStack(spacing: 12) {
            // Thumbnail
            if let firstURL = item.imageURLs.first, let url = URL(string: firstURL) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        imagePlaceholder
                    case .empty:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(.systemGray6))
                    @unknown default:
                        imagePlaceholder
                    }
                }
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(8)
            } else {
                imagePlaceholder
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }
            
            // Details
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                HStack(spacing: 6) {
                    Image(systemName: item.category.icon)
                        .font(.system(size: 10))
                    Text(item.category.rawValue)
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                
                Text(item.formattedPrice)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.accentColor)
            }
            
            Spacer()
            
            // Status badge
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.isAvailable ? "Active" : "Sold")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(item.isAvailable ? Color.green.opacity(0.15) : Color.orange.opacity(0.15))
                    .foregroundStyle(item.isAvailable ? .green : .orange)
                    .cornerRadius(8)
                
                Text(item.timeAgo)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var imagePlaceholder: some View {
        Color(.systemGray5)
            .overlay {
                Image(systemName: "photo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
    }
}

// MARK: - Stat Badge
struct StatBadge: View {
    let count: Int
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(count)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MyAdsView(authViewModel: AuthViewModel(), itemViewModel: ItemViewModel())
}
