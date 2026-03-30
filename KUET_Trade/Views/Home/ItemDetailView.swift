//
//  ItemDetailView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

struct ItemDetailView: View {
    let item: Item
    @State private var selectedImageIndex: Int = 0
    @State private var showContactSheet: Bool = false
    
    // Check if current user is the seller
    private var isOwnItem: Bool {
        guard let currentUID = AuthViewModel.shared.currentUser?.uid else { return false }
        return currentUID == item.sellerID
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // MARK: - Sold Banner
                if !item.isAvailable {
                    HStack(spacing: 8) {
                        Image(systemName: "tag.slash.fill")
                            .font(.subheadline)
                        Text("This item has been sold")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.red.gradient)
                }
                
                // MARK: - Image Gallery
                if !item.imageURLs.isEmpty {
                    ZStack(alignment: .bottom) {
                        TabView(selection: $selectedImageIndex) {
                            ForEach(item.imageURLs.indices, id: \.self) { index in
                                if let url = URL(string: item.imageURLs[index]) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        case .failure:
                                            galleryPlaceholder
                                        case .empty:
                                            ProgressView()
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .background(Color(.systemGray6))
                                        @unknown default:
                                            galleryPlaceholder
                                        }
                                    }
                                    .tag(index)
                                }
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: item.imageURLs.count > 1 ? .always : .never))
                        .frame(height: 300)
                        .background(Color(.systemGray6))
                        
                        // SOLD overlay on image gallery
                        if !item.isAvailable {
                            Color.black.opacity(0.3)
                                .frame(height: 300)
                                .overlay {
                                    Text("SOLD")
                                        .font(.largeTitle)
                                        .fontWeight(.heavy)
                                        .foregroundStyle(.white.opacity(0.8))
                                        .rotationEffect(.degrees(-15))
                                }
                                .allowsHitTesting(false)
                        }
                    }
                    
                    // Image counter
                    if item.imageURLs.count > 1 {
                        Text("\(selectedImageIndex + 1) / \(item.imageURLs.count)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 6)
                    }
                } else {
                    galleryPlaceholder
                        .frame(height: 220)
                }
                
                // MARK: - Item Info
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Title & Price
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(item.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            // Own item badge
                            if isOwnItem {
                                Text("Your Ad")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.orange)
                                    .cornerRadius(6)
                            }
                        }
                        
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(item.formattedPrice)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(item.isAvailable ? Color.accentColor : .secondary)
                            
                            if !item.isAvailable {
                                Text("SOLD")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.red)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Category & Time
                    HStack(spacing: 16) {
                        // Category
                        HStack(spacing: 6) {
                            Image(systemName: item.category.icon)
                                .font(.caption)
                            Text(item.category.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.1))
                        .foregroundStyle(Color.accentColor)
                        .cornerRadius(8)
                        
                        Spacer()
                        
                        // Time
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                            Text("Posted \(item.timeAgo)")
                                .font(.subheadline)
                        }
                        .foregroundStyle(.secondary)
                    }
                    
                    Divider()
                    
                    // MARK: - Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(item.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Divider()
                    
                    // MARK: - Seller Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Seller Information")
                            .font(.headline)
                        
                        HStack(spacing: 12) {
                            // Avatar
                            ZStack {
                                Circle()
                                    .fill(Color.accentColor.opacity(0.15))
                                    .frame(width: 48, height: 48)
                                
                                Text(sellerInitials)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.accentColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(item.sellerName)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    if isOwnItem {
                                        Text("(You)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "phone.fill")
                                        .font(.caption2)
                                    Text(item.sellerPhone)
                                        .font(.caption)
                                }
                                .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            // Quick contact button — hide for own items
                            if !isOwnItem && item.isAvailable {
                                Button {
                                    showContactSheet = true
                                } label: {
                                    Image(systemName: "ellipsis.message.fill")
                                        .font(.title3)
                                        .foregroundStyle(Color.accentColor)
                                        .padding(10)
                                        .background(Color.accentColor.opacity(0.12))
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                    
                    // MARK: - Contact Buttons (only for other sellers' available items)
                    if !isOwnItem && item.isAvailable {
                        Divider()
                        
                        // Contact Buttons (Compact)
                        ContactSellerCompactRow(phone: item.sellerPhone, itemTitle: item.title)
                        
                        Divider()
                        
                        // Contact Buttons (Full)
                        ContactSellerButtons(phone: item.sellerPhone, itemTitle: item.title)
                        
                        // Safety tip
                        HStack(spacing: 6) {
                            Image(systemName: "shield.checkered")
                                .font(.caption)
                            Text("Meet in a safe, public place on campus for exchanges.")
                                .font(.caption)
                        }
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                    } else if isOwnItem {
                        Divider()
                        
                        // Own item info
                        HStack(spacing: 8) {
                            Image(systemName: "info.circle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                            Text("This is your listing. Manage it from the My Ads tab.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.08))
                        .cornerRadius(10)
                    } else if !item.isAvailable {
                        Divider()
                        
                        // Sold item info
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.subheadline)
                                .foregroundStyle(.orange)
                            Text("This item has been sold and is no longer available.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.orange.opacity(0.08))
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !isOwnItem && item.isAvailable {
                    Button {
                        showContactSheet = true
                    } label: {
                        Image(systemName: "phone.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
        .sheet(isPresented: $showContactSheet) {
            ContactSellerSheet(item: item)
                .presentationDetents([.medium, .large])
        }
    }
    
    // MARK: - Seller Initials
    private var sellerInitials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: item.sellerName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return String(item.sellerName.prefix(2)).uppercased()
    }
    
    // MARK: - Gallery Placeholder
    private var galleryPlaceholder: some View {
        ZStack {
            Color(.systemGray6)
            VStack(spacing: 6) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
                Text("No Photos")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ItemDetailView(item: Item(
            id: "1",
            title: "Data Structures & Algorithms Textbook (CLRS 4th Edition)",
            description: "Almost new condition. Used for only one semester in CSE 2101 class. No marks or highlights. Original price was ৳800.",
            price: 450,
            category: .books,
            imageURLs: [],
            sellerID: "abc",
            sellerName: "Himel Rahman",
            sellerPhone: "01712345678"
        ))
    }
}
