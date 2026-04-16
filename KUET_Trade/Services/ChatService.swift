//
//  ChatService.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseFirestore

final class ChatService {
    static let shared = ChatService()

    private let db = Firestore.firestore()

    private init() {}

    private var conversationsCollection: CollectionReference {
        db.collection(AppConstants.Collections.conversations)
    }

    private func messagesCollection(conversationId: String) -> CollectionReference {
        conversationsCollection.document(conversationId).collection(AppConstants.Collections.messages)
    }

    private func conversationId(
        currentUserId: String,
        otherUserId: String,
        itemId: String?
    ) -> String {
        let pair = [currentUserId, otherUserId].sorted().joined(separator: "_")
        let safeItem = itemId ?? "general"
        return "\(pair)_\(safeItem)"
    }

    func createOrGetConversation(
        currentUser: KTUser,
        otherUserId: String,
        otherUserName: String,
        item: Item?
    ) async throws -> Conversation {
        let convoId = conversationId(currentUserId: currentUser.uid, otherUserId: otherUserId, itemId: item?.id)
        let ref = conversationsCollection.document(convoId)

        let conversation = Conversation(
            id: convoId,
            participants: [currentUser.uid, otherUserId],
            participantNames: [
                currentUser.uid: currentUser.name,
                otherUserId: otherUserName
            ],
            lastMessage: "Conversation started",
            lastMessageTime: Date(),
            itemId: item?.id,
            itemTitle: item?.title,
            unreadCount: [
                currentUser.uid: 0,
                otherUserId: 0
            ],
            participantLastActive: [
                currentUser.uid: Date(),
                otherUserId: Date()
            ]
        )

        do {
            let existing = try await ref.getDocument()
            if existing.exists {
                if let decoded = try? existing.data(as: Conversation.self) {
                    return decoded
                }

                // Repair malformed docs with required defaults.
                try await ref.setData(from: conversation, merge: true)
                return conversation
            }

            try await ref.setData(from: conversation)
            return conversation
        } catch {
            // Some rules deny reads for non-existing documents. Try create path directly.
            if isPermissionDenied(error) {
                do {
                    try await ref.setData(from: conversation)
                    return conversation
                } catch {
                    throw error
                }
            }
            throw error
        }
    }

    func fetchConversations(for userId: String) async throws -> [Conversation] {
        let snapshot = try await conversationsCollection
            .whereField("participants", arrayContains: userId)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Conversation.self) }
    }

    func listenToConversations(
        for userId: String,
        completion: @escaping ([Conversation]) -> Void
    ) -> ListenerRegistration {
        conversationsCollection
            .whereField("participants", arrayContains: userId)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let conversations = documents.compactMap { try? $0.data(as: Conversation.self) }
                completion(conversations)
            }
    }

    func sendMessage(
        conversation: Conversation,
        sender: KTUser,
        text: String
    ) async throws {
        guard let conversationId = conversation.id else { return }

        let trimmed = text.trimmed
        guard !trimmed.isEmpty else { return }

        let message = Message(
            senderId: sender.uid,
            senderName: sender.name,
            text: trimmed
        )

        let messageRef = messagesCollection(conversationId: conversationId).document()
        try messageRef.setData(from: message)

        var updatePayload: [String: Any] = [
            "lastMessage": trimmed,
            "lastMessageTime": Timestamp(date: Date()),
            "participantLastActive.\(sender.uid)": Timestamp(date: Date())
        ]

        if let recipientId = conversation.participants.first(where: { $0 != sender.uid }) {
            let unreadPath = "unreadCount.\(recipientId)"
            updatePayload[unreadPath] = FieldValue.increment(Int64(1))
        }

        try await conversationsCollection.document(conversationId).setData(updatePayload, merge: true)
    }

    func markConversationRead(conversationId: String, userId: String) async throws {
        try await conversationsCollection.document(conversationId).setData([
            "unreadCount.\(userId)": 0
        ], merge: true)
    }

    func markMessagesRead(conversationId: String, userId: String) async throws {
        let snapshot = try await messagesCollection(conversationId: conversationId).getDocuments()
        let unreadIncoming = snapshot.documents.filter { doc in
            let data = doc.data()
            let isRead = data["isRead"] as? Bool ?? false
            let senderId = data["senderId"] as? String ?? ""
            return !isRead && senderId != userId
        }

        guard !unreadIncoming.isEmpty else { return }

        let batch = db.batch()
        for doc in unreadIncoming {
            batch.updateData(["isRead": true], forDocument: doc.reference)
        }
        try await batch.commit()
    }

    func fetchMessages(conversationId: String) async throws -> [Message] {
        let snapshot = try await messagesCollection(conversationId: conversationId)
            .order(by: "timestamp", descending: false)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Message.self) }
    }

    func setTypingStatus(conversationId: String, userId: String, isTyping: Bool) async throws {
        try await conversationsCollection.document(conversationId).setData([
            "typingStatus.\(userId)": isTyping,
            "participantLastActive.\(userId)": Timestamp(date: Date())
        ], merge: true)
    }

    func listenToTypingStatus(
        conversationId: String,
        currentUserId: String,
        completion: @escaping (Bool) -> Void
    ) -> ListenerRegistration {
        conversationsCollection.document(conversationId).addSnapshotListener { snapshot, _ in
            guard let data = snapshot?.data() else {
                completion(false)
                return
            }

            let typingMap = data["typingStatus"] as? [String: Bool] ?? [:]
            let otherUserTyping = typingMap.first { $0.key != currentUserId }?.value ?? false
            completion(otherUserTyping)
        }
    }

    func listenToMessages(
        conversationId: String,
        completion: @escaping ([Message]) -> Void
    ) -> ListenerRegistration {
        messagesCollection(conversationId: conversationId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }

                let messages = documents.compactMap { try? $0.data(as: Message.self) }
                completion(messages)
            }
    }
}

private extension ChatService {
    func isPermissionDenied(_ error: Error) -> Bool {
        let nsError = error as NSError
        return nsError.code == FirestoreErrorCode.permissionDenied.rawValue
    }
}
