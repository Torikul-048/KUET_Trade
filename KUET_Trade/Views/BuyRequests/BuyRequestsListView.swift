//
//  BuyRequestsListView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct BuyRequestsListView: View {
    @StateObject private var viewModel = BuyRequestViewModel()
    @State private var showPostSheet = false

    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    ProgressView("Loading requests...")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else if viewModel.requests.isEmpty {
                    ContentUnavailableView(
                        "No Buy Requests",
                        systemImage: "hand.raised",
                        description: Text("Be the first to post what you need.")
                    )
                } else {
                    ForEach(viewModel.requests) { request in
                        NavigationLink(destination: BuyRequestDetailView(request: request)) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(request.title)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                    Spacer()
                                    Text("৳\(String(format: "%.0f", request.maxBudget))")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.kuetGreen)
                                }

                                HStack(spacing: 6) {
                                    Image(systemName: request.category.icon)
                                    Text(request.category.rawValue)
                                    Text("•")
                                    Text(request.timeAgo)
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)

                                Text(request.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Buy Requests")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPostSheet = true
                    } label: {
                        Label("Post", systemImage: "plus")
                    }
                }
            }
            .task {
                await viewModel.loadRequests()
            }
            .refreshable {
                await viewModel.loadRequests()
            }
            .sheet(isPresented: $showPostSheet) {
                PostBuyRequestView(viewModel: viewModel)
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
    BuyRequestsListView()
}
