//
//  Message.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseFirestore

enum MessageType: String, Codable {
    case text
}

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var senderId: String
    var senderName: String
    var text: String
    var timestamp: Date
    var isRead: Bool
    var type: MessageType

    init(
        id: String? = nil,
        senderId: String,
        senderName: String,
        text: String,
        timestamp: Date = Date(),
        isRead: Bool = false,
        type: MessageType = .text
    ) {
        self.id = id
        self.senderId = senderId
        self.senderName = senderName
        self.text = text
        self.timestamp = timestamp
        self.isRead = isRead
        self.type = type
    }
}
