//
//  ChatViewModel.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var messages: [Message] = []
    @Published var composedMessage: String = ""

    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var isOtherUserTyping = false

    private var messagesListener: ListenerRegistration?
    private var conversationsListener: ListenerRegistration?
    private var typingListener: ListenerRegistration?
    private var typingDebounceTask: Task<Void, Never>?
    private var lastTypingStatusSent = false

    deinit {
        messagesListener?.remove()
        conversationsListener?.remove()
        typingListener?.remove()
        typingDebounceTask?.cancel()
    }

    func loadConversations(currentUserId: String) async {
        isLoading = true
        defer { isLoading = false }

        do {
            conversations = try await ChatService.shared.fetchConversations(for: currentUserId)
            conversations.sort { $0.lastMessageTime > $1.lastMessageTime }
        } catch {
            showError("Failed to load conversations: \(error.localizedDescription)")
        }
    }

    func startListeningMessages(conversationId: String) {
        messagesListener?.remove()

        messagesListener = ChatService.shared.listenToMessages(conversationId: conversationId) { [weak self] incoming in
            Task { @MainActor in
                self?.messages = incoming
            }
        }
    }

    func loadMessages(conversationId: String) async {
        do {
            messages = try await ChatService.shared.fetchMessages(conversationId: conversationId)
        } catch {
            showError("Failed to refresh messages: \(error.localizedDescription)")
        }
    }

    func stopListeningMessages() {
        messagesListener?.remove()
        messagesListener = nil
    }

    func startListeningTyping(conversationId: String, currentUserId: String) {
        typingListener?.remove()

        typingListener = ChatService.shared.listenToTypingStatus(
            conversationId: conversationId,
            currentUserId: currentUserId
        ) { [weak self] isTyping in
            Task { @MainActor in
                self?.isOtherUserTyping = isTyping
            }
        }
    }

    func stopListeningTyping() {
        typingListener?.remove()
        typingListener = nil
        isOtherUserTyping = false
    }

    func startListeningConversations(currentUserId: String) {
        isLoading = true
        conversationsListener?.remove()

        conversationsListener = ChatService.shared.listenToConversations(for: currentUserId) { [weak self] incoming in
            Task { @MainActor in
                self?.conversations = incoming.sorted { $0.lastMessageTime > $1.lastMessageTime }
                self?.isLoading = false
            }
        }
    }

    func stopListeningConversations() {
        conversationsListener?.remove()
        conversationsListener = nil
    }

    func sendMessage(conversation: Conversation, sender: KTUser) async {
        let outgoing = composedMessage.trimmed
        guard !outgoing.isEmpty else { return }

        let localMessage = Message(
            senderId: sender.uid,
            senderName: sender.name,
            text: outgoing
        )

        messages.append(localMessage)
        composedMessage = ""

        do {
            try await ChatService.shared.sendMessage(conversation: conversation, sender: sender, text: outgoing)

            if let conversationId = conversation.id {
                await setTypingStatus(conversationId: conversationId, userId: sender.uid, isTyping: false)
            }
        } catch {
            // Remove optimistic message on failure
            messages.removeAll { $0.id == localMessage.id && $0.timestamp == localMessage.timestamp }
            showError("Failed to send message: \(error.localizedDescription)")
        }
    }

    func handleComposerTextChange(conversationId: String, userId: String, text: String) {
        let isTyping = !text.trimmed.isEmpty

        typingDebounceTask?.cancel()
        typingDebounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 350_000_000)
            await self?.setTypingStatus(conversationId: conversationId, userId: userId, isTyping: isTyping)
        }
    }

    func clearTypingState(conversationId: String, userId: String) async {
        typingDebounceTask?.cancel()
        await setTypingStatus(conversationId: conversationId, userId: userId, isTyping: false)
    }

    func markRead(conversationId: String, userId: String) async {
        do {
            try await ChatService.shared.markConversationRead(conversationId: conversationId, userId: userId)
        } catch {
            showError("Failed to mark read: \(error.localizedDescription)")
        }
    }

    func markMessagesRead(conversationId: String, userId: String) async {
        do {
            try await ChatService.shared.markMessagesRead(conversationId: conversationId, userId: userId)
        } catch {
            showError("Failed to update message read status: \(error.localizedDescription)")
        }
    }

    private func showError(_ message: String) {
        errorMessage = message
        showError = true
    }

    private func setTypingStatus(conversationId: String, userId: String, isTyping: Bool) async {
        guard isTyping != lastTypingStatusSent else { return }

        do {
            try await ChatService.shared.setTypingStatus(
                conversationId: conversationId,
                userId: userId,
                isTyping: isTyping
            )
            lastTypingStatusSent = isTyping
        } catch {
            showError("Failed to update typing status: \(error.localizedDescription)")
        }
    }
}
