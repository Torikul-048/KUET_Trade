//
//  ReviewsListView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct ReviewsListView: View {
    let sellerId: String
    let sellerName: String
    let itemForWriting: Item?

    @StateObject private var viewModel = ReviewViewModel()
    @State private var showWriteReview = false

    init(sellerId: String, sellerName: String, itemForWriting: Item? = nil) {
        self.sellerId = sellerId
        self.sellerName = sellerName
        self.itemForWriting = itemForWriting
    }

    private var canWriteReview: Bool {
        guard let user = AuthViewModel.shared.currentUser else { return false }
        return user.uid != sellerId && itemForWriting != nil
    }

    var body: some View {
        List {
            Section {
                HStack {
                    StarRatingView(rating: viewModel.averageRating, size: 18)
                    Text(String(format: "%.1f", viewModel.averageRating))
                        .fontWeight(.semibold)
                    Text("(\(viewModel.totalReviews) reviews)")
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text("\(sellerName)'s Ratings")
            }

            if canWriteReview {
                Section {
                    Button {
                        showWriteReview = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.pencil")
                            Text("Write Review & Rating")
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                } footer: {
                    Text("Stars shown on this page are summary-only. Use this button to submit your own rating and review.")
                }
            }

            Section("Reviews") {
                if viewModel.reviews.isEmpty {
                    ContentUnavailableView(
                        "No Reviews Yet",
                        systemImage: "star",
                        description: Text("Be the first person to leave feedback.")
                    )
                } else {
                    ForEach(viewModel.reviews) { review in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(review.reviewerName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Spacer()
                                Text(review.formattedDate)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            StarRatingView(rating: review.rating)

                            Text(review.comment)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if review.isVerifiedPurchase {
                                Label("Verified purchase", systemImage: "checkmark.seal.fill")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Reviews")
        .toolbar {
            if canWriteReview {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showWriteReview = true
                    } label: {
                        Label("Write", systemImage: "square.and.pencil")
                    }
                }
            }
        }
        .task {
            await viewModel.loadReviews(sellerId: sellerId)
        }
        .refreshable {
            await viewModel.loadReviews(sellerId: sellerId)
        }
        .sheet(isPresented: $showWriteReview) {
            if let itemForWriting {
                WriteReviewView(item: itemForWriting, viewModel: viewModel)
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
    }
}

#Preview {
    NavigationStack {
        ReviewsListView(sellerId: "seller", sellerName: "Seller Name")
    }
}
