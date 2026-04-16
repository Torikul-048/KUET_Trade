//
//  StarRatingView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct StarRatingView: View {
    private let rating: Double
    private let maxRating: Int
    private let size: CGFloat
    private let color: Color
    private let editableRating: Binding<Int>?

    init(rating: Double, maxRating: Int = 5, size: CGFloat = 16, color: Color = .yellow) {
        self.rating = rating
        self.maxRating = maxRating
        self.size = size
        self.color = color
        self.editableRating = nil
    }

    init(selectedRating: Binding<Int>, maxRating: Int = 5, size: CGFloat = 20, color: Color = .yellow) {
        self.rating = Double(selectedRating.wrappedValue)
        self.maxRating = maxRating
        self.size = size
        self.color = color
        self.editableRating = selectedRating
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                if let editableRating {
                    Button {
                        editableRating.wrappedValue = index
                    } label: {
                        Image(systemName: editableRating.wrappedValue >= index ? "star.fill" : "star")
                            .font(.system(size: size))
                            .foregroundStyle(color)
                    }
                    .buttonStyle(.plain)
                } else {
                    Image(systemName: starType(for: index))
                        .font(.system(size: size))
                        .foregroundStyle(color)
                }
            }
        }
    }

    private func starType(for index: Int) -> String {
        if Double(index) <= rating {
            return "star.fill"
        } else if Double(index) - 0.5 <= rating {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        StarRatingView(rating: 4.3)
        StarRatingView(selectedRating: .constant(3))
    }
}
