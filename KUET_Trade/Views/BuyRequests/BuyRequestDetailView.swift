//
//  BuyRequestDetailView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct BuyRequestDetailView: View {
    let request: BuyRequest
    @State private var showContactSheet = false
    @State private var isPreparingChat = false
    @State private var chatConversation: Conversation?
    @State private var chatErrorMessage: String?
    @State private var showChatError = false

    private var isOwnRequest: Bool {
        AuthViewModel.shared.currentUser?.uid == request.buyerId
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(request.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(request.formattedBudget)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.kuetGreen)

                    HStack(spacing: 6) {
                        Image(systemName: request.category.icon)
                        Text(request.category.rawValue)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Description")
                        .font(.headline)
                    Text(request.description)
                        .foregroundStyle(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Posted By")
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.kuetGreen.opacity(0.15))
                                .frame(width: 44, height: 44)
                            Text(String(request.buyerName.prefix(1)).uppercased())
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(Color.kuetGreen)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(request.buyerName)
                                .fontWeight(.medium)
                            HStack(spacing: 4) {
                                Image(systemName: "phone.fill")
                                    .font(.caption2)
                                Text(request.buyerPhone)
                                    .font(.subheadline)
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                    
                    Text("Posted \(request.timeAgo)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if !isOwnRequest {
                    Divider()
                    
                    // Message Buyer button
                    Button {
                        Task {
                            await startConversation()
                        }
                    } label: {
                        HStack {
                            if isPreparingChat {
                                ProgressView()
                                    .tint(.white)
                            }
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Message Buyer")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.kuetGreen)
                        .foregroundStyle(.white)
                        .cornerRadius(14)
                    }
                    .disabled(isPreparingChat)
                    
                    // Call Buyer button
                    Button {
                        callBuyer()
                    } label: {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Call Buyer")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.kuetGreen.opacity(0.12))
                        .foregroundStyle(Color.kuetGreen)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.kuetGreen, lineWidth: 1)
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Request Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isOwnRequest {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        callBuyer()
                    } label: {
                        Image(systemName: "phone.circle.fill")
                    }
                }
            }
        }
        .sheet(item: $chatConversation) { conversation in
            NavigationStack {
                ChatView(conversation: conversation)
            }
        }
        .alert("Chat Error", isPresented: $showChatError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(chatErrorMessage ?? "Unable to open chat.")
        }
    }

    private func callBuyer() {
        let cleaned = request.buyerPhone
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        guard let url = URL(string: "tel:\(cleaned)") else { return }
        UIApplication.shared.open(url)
    }
    
    private func startConversation() async {
        guard !isOwnRequest else { return }
        guard let currentUser = AuthViewModel.shared.currentUser else {
            chatErrorMessage = "Please login to start messaging."
            showChatError = true
            return
        }

        isPreparingChat = true
        defer { isPreparingChat = false }

        do {
            let conversation = try await ChatService.shared.createOrGetConversation(
                currentUser: currentUser,
                otherUserId: request.buyerId,
                otherUserName: request.buyerName,
                item: nil
            )
            chatConversation = conversation
        } catch {
            chatErrorMessage = "Unable to open chat: \(error.localizedDescription)"
            showChatError = true
        }
    }
}

#Preview {
    NavigationStack {
        BuyRequestDetailView(
            request: BuyRequest(
                title: "Need scientific calculator",
                description: "Looking for a calculator in good condition.",
                category: .electronics,
                maxBudget: 1500,
                buyerId: "abc",
                buyerName: "Buyer",
                buyerPhone: "01712345678"
            )
        )
    }
}
