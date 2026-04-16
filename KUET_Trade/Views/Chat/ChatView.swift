//
//  ChatView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI
import UIKit

struct ChatView: View {
    let conversation: Conversation
    @StateObject private var viewModel = ChatViewModel()
    @State private var didInitializeMessageStream = false
    @State private var isNearBottom = true

    private var currentUser: KTUser? {
        AuthViewModel.shared.currentUser
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.messages.isEmpty {
                ContentUnavailableView(
                    "No Messages Yet",
                    systemImage: "bubble.left.and.bubble.right",
                    description: Text("Start the conversation.")
                )
                .overlay(alignment: .bottom) {
                    Button("Refresh") {
                        Task {
                            guard let conversationId = conversation.id else { return }
                            await viewModel.loadMessages(conversationId: conversationId)
                        }
                    }
                    .buttonStyle(.bordered)
                    .padding(.bottom, 24)
                }
            } else {
                ScrollViewReader { proxy in
                    GeometryReader { scrollGeometry in
                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { index, message in
                                    if shouldShowDateDivider(at: index) {
                                        dateDivider(for: message.timestamp)
                                    }

                                    if index == firstUnreadIncomingIndex {
                                        unreadDivider
                                    }

                                    let previousMessage = index > 0 ? viewModel.messages[index - 1] : nil
                                    let nextMessage = index < (viewModel.messages.count - 1) ? viewModel.messages[index + 1] : nil
                                    let groupedWithPrevious = previousMessage?.senderId == message.senderId
                                    let showsTimestamp = nextMessage?.senderId != message.senderId

                                    MessageBubbleView(
                                        message: message,
                                        isCurrentUser: message.senderId == currentUser?.uid,
                                        showsTimestamp: showsTimestamp,
                                        groupedWithPrevious: groupedWithPrevious
                                    )
                                    .id(message.id)
                                    .transition(
                                        .asymmetric(
                                            insertion: .move(edge: .bottom).combined(with: .opacity),
                                            removal: .opacity
                                        )
                                    )
                                    .transaction { transaction in
                                        if !didInitializeMessageStream {
                                            transaction.animation = nil
                                        }
                                    }
                                }

                                Color.clear
                                    .frame(height: 1)
                                    .id("chat-bottom-anchor")
                                    .background(
                                        GeometryReader { geometry in
                                            Color.clear.preference(
                                                key: ChatBottomAnchorOffsetKey.self,
                                                value: geometry.frame(in: .named("chatScrollArea")).minY
                                            )
                                        }
                                    )
                            }
                            .animation(.easeOut(duration: 0.22), value: viewModel.messages.map(\.id))
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                        .coordinateSpace(name: "chatScrollArea")
                        .onPreferenceChange(ChatBottomAnchorOffsetKey.self) { bottomAnchorMinY in
                            let nearBottomThreshold = scrollGeometry.size.height + 72
                            let nearBottom = bottomAnchorMinY <= nearBottomThreshold
                            if nearBottom != isNearBottom {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    isNearBottom = nearBottom
                                }
                            }
                        }
                        .overlay(alignment: .bottomTrailing) {
                            if !isNearBottom && !viewModel.messages.isEmpty {
                                Button {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                        proxy.scrollTo("chat-bottom-anchor", anchor: .bottom)
                                    }
                                } label: {
                                    Label("Latest", systemImage: "chevron.down")
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .foregroundStyle(.white)
                                        .background(Color.kuetGreen)
                                        .clipShape(Capsule())
                                }
                                .padding(.trailing, 14)
                                .padding(.bottom, 12)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .refreshable {
                            guard let conversationId = conversation.id else { return }
                            await viewModel.loadMessages(conversationId: conversationId)
                        }
                        .onChange(of: viewModel.messages.count) { _, _ in
                            guard let lastMessage = viewModel.messages.last else { return }
                            let sentByCurrentUser = lastMessage.senderId == currentUser?.uid

                            if isNearBottom || sentByCurrentUser {
                                withAnimation {
                                    proxy.scrollTo(lastMessage.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
            }

            Divider()

            if viewModel.isOtherUserTyping {
                HStack {
                    TypingIndicatorView()
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .transition(.opacity)
            }

            HStack(spacing: 8) {
                TextField("Type a message...", text: $viewModel.composedMessage, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...4)
                    .submitLabel(.send)
                    .onSubmit {
                        Task {
                            await sendCurrentMessage()
                        }
                    }

                Button {
                    Task {
                        await sendCurrentMessage()
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 38, height: 38)
                        .background(Color.kuetGreen)
                        .clipShape(Circle())
                }
                .disabled(viewModel.composedMessage.trimmed.isEmpty || currentUser == nil)
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard let currentUserId = currentUser?.uid, let conversationId = conversation.id else { return }
            viewModel.startListeningMessages(conversationId: conversationId)
            viewModel.startListeningTyping(conversationId: conversationId, currentUserId: currentUserId)
            await viewModel.markRead(conversationId: conversationId, userId: currentUserId)
            await viewModel.markMessagesRead(conversationId: conversationId, userId: currentUserId)
        }
        .onChange(of: viewModel.composedMessage) { _, newValue in
            guard let currentUserId = currentUser?.uid, let conversationId = conversation.id else { return }
            viewModel.handleComposerTextChange(
                conversationId: conversationId,
                userId: currentUserId,
                text: newValue
            )
        }
        .onChange(of: viewModel.messages.count) { _, _ in
            guard let currentUserId = currentUser?.uid, let conversationId = conversation.id else { return }

            if !didInitializeMessageStream {
                didInitializeMessageStream = true
            } else if let lastMessage = viewModel.messages.last,
                      lastMessage.senderId != currentUserId {
                triggerIncomingMessageHaptic()
            }

            Task {
                await viewModel.markMessagesRead(conversationId: conversationId, userId: currentUserId)
            }
        }
        .onDisappear {
            guard let currentUserId = currentUser?.uid, let conversationId = conversation.id else {
                viewModel.stopListeningMessages()
                viewModel.stopListeningTyping()
                return
            }

            Task {
                await viewModel.clearTypingState(conversationId: conversationId, userId: currentUserId)
            }

            viewModel.stopListeningMessages()
            viewModel.stopListeningTyping()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Unknown error")
        }
    }

    private var title: String {
        guard let currentUserId = currentUser?.uid else { return "Chat" }
        return conversation.displayName(for: currentUserId)
    }

    private var firstUnreadIncomingIndex: Int? {
        guard let currentUserId = currentUser?.uid else { return nil }
        return viewModel.messages.firstIndex {
            !$0.isRead && $0.senderId != currentUserId
        }
    }

    private var unreadDivider: some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(Color.orange.opacity(0.5))
                .frame(height: 1)

            Text("New messages")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.orange)

            Rectangle()
                .fill(Color.orange.opacity(0.5))
                .frame(height: 1)
        }
        .padding(.vertical, 4)
    }

    private func shouldShowDateDivider(at index: Int) -> Bool {
        guard index < viewModel.messages.count else { return false }
        if index == 0 { return true }

        let currentDate = viewModel.messages[index].timestamp
        let previousDate = viewModel.messages[index - 1].timestamp
        return !Calendar.current.isDate(currentDate, inSameDayAs: previousDate)
    }

    @ViewBuilder
    private func dateDivider(for date: Date) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(Color.secondary.opacity(0.25))
                .frame(height: 1)

            Text(formattedDayLabel(for: date))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)

            Rectangle()
                .fill(Color.secondary.opacity(0.25))
                .frame(height: 1)
        }
        .padding(.vertical, 6)
    }

    private func formattedDayLabel(for date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        }
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    private func sendCurrentMessage() async {
        guard let currentUser, !viewModel.composedMessage.trimmed.isEmpty else { return }
        let messageBeforeSend = viewModel.composedMessage
        await viewModel.sendMessage(conversation: conversation, sender: currentUser)

        if !messageBeforeSend.trimmed.isEmpty && viewModel.composedMessage.isEmpty {
            triggerSendSuccessHaptic()
        }
    }

    private func triggerSendSuccessHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    private func triggerIncomingMessageHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}

private struct ChatBottomAnchorOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .greatestFiniteMagnitude

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct TypingIndicatorView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 6) {
            Text("Typing")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 5, height: 5)
                        .scaleEffect(isAnimating ? 1.0 : 0.55)
                        .opacity(isAnimating ? 1.0 : 0.35)
                        .animation(
                            .easeInOut(duration: 0.55)
                                .repeatForever()
                                .delay(Double(index) * 0.14),
                            value: isAnimating
                        )
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(
            conversation: Conversation(
                id: "demo",
                participants: ["1", "2"],
                participantNames: ["1": "A", "2": "B"],
                lastMessage: "Hi",
                lastMessageTime: Date(),
                itemId: nil,
                itemTitle: "Demo Item",
                unreadCount: ["1": 0, "2": 2]
            )
        )
    }
}
