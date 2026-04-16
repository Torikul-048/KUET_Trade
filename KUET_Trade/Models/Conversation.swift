//
//  Conversation.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseFirestore

struct Conversation: Identifiable, Codable {
    @DocumentID var id: String?
    var participants: [String]
    var participantNames: [String: String]
    var lastMessage: String
    var lastMessageTime: Date
    var itemId: String?
    var itemTitle: String?
    var unreadCount: [String: Int]
    var participantLastActive: [String: Date]?

    func displayName(for currentUserId: String) -> String {
        let otherId = participants.first { $0 != currentUserId }
        if let otherId, let name = participantNames[otherId], !name.isEmpty {
            return name
        }
        return "Unknown User"
    }

    func unread(for userId: String) -> Int {
        unreadCount[userId] ?? 0
    }

    func lastActiveDate(for userId: String) -> Date? {
        participantLastActive?[userId]
    }
}
