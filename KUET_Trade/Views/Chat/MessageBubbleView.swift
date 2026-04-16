//
//  MessageBubbleView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    let isCurrentUser: Bool
    var showsTimestamp: Bool = true
    var groupedWithPrevious: Bool = false

    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer(minLength: 50)
            }

            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .font(.body)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(isCurrentUser ? Color.kuetGreen : Color(.secondarySystemBackground))
                    .foregroundStyle(isCurrentUser ? .white : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                if showsTimestamp {
                    HStack(spacing: 4) {
                        Text(message.timestamp.formatted(date: .omitted, time: .shortened))

                        if isCurrentUser {
                            Text(message.isRead ? "Read" : "Sent")
                        }
                    }
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }

            if !isCurrentUser {
                Spacer(minLength: 50)
            }
        }
        .padding(.top, groupedWithPrevious ? 2 : 8)
    }
}

#Preview {
    VStack {
        MessageBubbleView(message: Message(senderId: "1", senderName: "A", text: "Hi"), isCurrentUser: true)
        MessageBubbleView(message: Message(senderId: "2", senderName: "B", text: "Hello!"), isCurrentUser: false)
    }
    .padding()
}
