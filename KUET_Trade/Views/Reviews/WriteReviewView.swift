//
//  WriteReviewView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct WriteReviewView: View {
    let item: Item
    @ObservedObject var viewModel: ReviewViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Rating") {
                    VStack(alignment: .leading, spacing: 10) {
                        StarRatingView(selectedRating: $viewModel.selectedRating, size: 28)
                        Text("Selected: \(viewModel.selectedRating)/5")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Comment") {
                    TextEditor(text: $viewModel.comment)
                        .frame(minHeight: 120)
                }

                Section {
                    Toggle("Verified purchase", isOn: $viewModel.isVerifiedPurchase)
                } footer: {
                    Text("Enable this only if the transaction was completed.")
                }
            }
            .navigationTitle("Write Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        Task {
                            guard let currentUser = AuthViewModel.shared.currentUser else {
                                viewModel.errorMessage = "You must be logged in to write a review."
                                viewModel.showError = true
                                return
                            }
                            await viewModel.submitReview(item: item, reviewer: currentUser)
                            if viewModel.didSubmit {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }
}

#Preview {
    WriteReviewView(
        item: Item(
            title: "Sample",
            description: "Sample",
            price: 100,
            category: .books,
            sellerID: "seller",
            sellerName: "Seller",
            sellerPhone: "01700000000"
        ),
        viewModel: ReviewViewModel()
    )
}
