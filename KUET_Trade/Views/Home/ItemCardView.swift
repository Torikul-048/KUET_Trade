//
//  ItemCardView.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

struct ItemCardView: View {
    let item: Item
    private let imageHeight: CGFloat = 160

    private var firstValidImageURL: URL? {
        item.imageURLs
            .compactMap { $0.normalizedURL }
            .first
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // MARK: - Image
            // Rectangle base + overlays: grid column constrains width,
            // preventing .scaledToFill images from bleeding outside the card.
            Rectangle()
                .fill(Color(.systemGray6))
                .frame(maxWidth: .infinity)
                .frame(height: imageHeight)
                .overlay {
                    if let url = firstValidImageURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                imagePlaceholder
                            case .empty:
                                Color(.systemGray6)
                                    .overlay(ProgressView())
                            @unknown default:
                                imagePlaceholder
                            }
                        }
                    } else {
                        imagePlaceholder
                    }
                }
                .clipped()
                .overlay {
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.35)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .allowsHitTesting(false)
                }
                // price badge removed from image — shown below in info row
                .overlay(alignment: .topTrailing) {
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
                }
                .overlay {
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
                    }
                }
                .contentShape(Rectangle())
            
            // MARK: - Info
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(item.formattedPrice)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(item.isAvailable ? Color.kuetGreen : .secondary)
                    Spacer(minLength: 4)
                    HStack(spacing: 3) {
                        Image(systemName: "clock")
                            .font(.system(size: 9))
                        Text(item.timeAgo)
                            .font(.caption2)
                    }
                    .foregroundStyle(.secondary)
                }
                Text(item.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .foregroundStyle(item.isAvailable ? .primary : .secondary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.black.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        .opacity(item.isAvailable ? 1.0 : 0.75)
        .frame(maxWidth: .infinity)
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
        sellerName: "Torikul",
        sellerPhone: "01712345678"
    )
    
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        ItemCardView(item: sampleItem)
        ItemCardView(item: sampleItem)
    }
    .padding()
}
