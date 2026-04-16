//
//  PostBuyRequestView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct PostBuyRequestView: View {
    @ObservedObject var viewModel: BuyRequestViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Request Details") {
                    TextField("What do you need?", text: $viewModel.title)

                    TextField("Describe item and condition", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...6)

                    TextField("Max budget (৳)", text: $viewModel.maxBudgetText)
                        .keyboardType(.numberPad)
                }

                Section("Category") {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(ItemCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }
            }
            .navigationTitle("Post Buy Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Post") {
                        Task {
                            guard let currentUser = AuthViewModel.shared.currentUser else {
                                viewModel.errorMessage = "Please login to post a request."
                                viewModel.showError = true
                                return
                            }
                            await viewModel.postRequest(currentUser: currentUser)
                            if viewModel.didPostSuccessfully {
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
    PostBuyRequestView(viewModel: BuyRequestViewModel())
}
