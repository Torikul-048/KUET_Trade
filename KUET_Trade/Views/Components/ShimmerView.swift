//
//  ShimmerView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

// MARK: - Shimmer Modifier
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0),
                            Color.white.opacity(0.3),
                            Color.white.opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geometry.size.width * 0.6)
                    .offset(x: -geometry.size.width * 0.3 + phase * geometry.size.width * 1.6)
                    .onAppear {
                        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                            phase = 1
                        }
                    }
                }
                .clipped()
            )
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - Skeleton Item Card
struct SkeletonItemCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(.systemGray5))
                .frame(height: 140)
                .shimmer()
            
            VStack(alignment: .leading, spacing: 8) {
                // Title line 1
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(height: 14)
                    .shimmer()
                
                // Title line 2 (shorter)
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 14)
                    .shimmer()
                
                // Price
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 70, height: 18)
                    .shimmer()
                
                // Time
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 60, height: 10)
                    .shimmer()
            }
            .padding(10)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Skeleton Grid (for loading state)
struct SkeletonGridView: View {
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<6, id: \.self) { _ in
                SkeletonItemCard()
            }
        }
        .padding(.horizontal)
    }
}

#Preview("Skeleton Card") {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
        SkeletonItemCard()
        SkeletonItemCard()
        SkeletonItemCard()
        SkeletonItemCard()
    }
    .padding()
}

#Preview("Skeleton Grid") {
    ScrollView {
        SkeletonGridView()
    }
}
