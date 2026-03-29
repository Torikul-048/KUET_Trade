//
//  ItemCardView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

struct ItemCardView: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // MARK: - Image
            ZStack(alignment: .topTrailing) {
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
                    .frame(height: 140)
                    .clipped()
                } else {
                    imagePlaceholder
                        .frame(height: 140)
                }
                
                // Category Badge
                HStack(spacing: 4) {
                    Image(systemName: item.category.icon)
                        .font(.system(size: 9))
                    Text(item.category.rawValue)
                        .font(.system(size: 10, weight: .semibold))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .padding(8)
                
                // SOLD overlay
                if !item.isAvailable {
                    ZStack {
                        Color.black.opacity(0.45)
                        
                        Text("SOLD")
                            .font(.title3)
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color.red.opacity(0.85))
                            .cornerRadius(8)
                    }
                    .frame(height: 140)
                }
            }
            
            // MARK: - Info
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(item.isAvailable ? .primary : .secondary)
                
                Text(item.formattedPrice)
                    .font(.headline)
                    .foregroundStyle(item.isAvailable ? Color.accentColor : .secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    Text(item.timeAgo)
                        .font(.caption2)
                }
                .foregroundStyle(.secondary)
            }
            .padding(10)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
        .opacity(item.isAvailable ? 1.0 : 0.75)
    }
    
    // MARK: - Placeholder
    private var imagePlaceholder: some View {
        ZStack {
            Color(.systemGray6)
            VStack(spacing: 4) {
                Image(systemName: "photo")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("No Image")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }
}

#Preview {
    let sampleItem = Item(
        id: "1",
        title: "Data Structures & Algorithms Textbook",
        description: "Like new condition",
        price: 350,
        category: .books,
        imageURLs: [],
        sellerID: "abc",
        sellerName: "Himel",
        sellerPhone: "01712345678"
    )
    
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ItemCardView(item: sampleItem)
        ItemCardView(item: sampleItem)
    }
    .padding()
}
