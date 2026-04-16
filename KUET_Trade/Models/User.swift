//
//  User.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import Foundation
import FirebaseFirestore

enum VerificationStatus: String, Codable {
    case pending
    case approved
    case rejected
}

struct KTUser: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String
    var name: String
    var email: String
    var phone: String
    var department: String
    var roll: String
    var batch: String
    var joinedDate: Date
    var profileImageURL: String?
    var isVerified: Bool
    var verificationStatus: VerificationStatus
    var refFriendName: String
    var refFriendRoll: String
    var refFriendDept: String
    var refFriendBatch: String
    var averageRating: Double?
    var totalReviews: Int?

    var safeAverageRating: Double {
        averageRating ?? 0
    }

    var safeTotalReviews: Int {
        totalReviews ?? 0
    }
    
    // Computed property for display
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return String(name.prefix(2)).uppercased()
    }
    
    // Default initializer
    init(
        id: String? = nil,
        uid: String,
        name: String,
        email: String,
        phone: String,
        department: String,
        roll: String = "",
        batch: String = "",
        joinedDate: Date = Date(),
        profileImageURL: String? = nil,
        isVerified: Bool = false,
        verificationStatus: VerificationStatus = .pending,
        refFriendName: String = "",
        refFriendRoll: String = "",
        refFriendDept: String = "",
        refFriendBatch: String = "",
        averageRating: Double? = 0,
        totalReviews: Int? = 0
    ) {
        self.id = id
        self.uid = uid
        self.name = name
        self.email = email
        self.phone = phone
        self.department = department
        self.roll = roll
        self.batch = batch
        self.joinedDate = joinedDate
        self.profileImageURL = profileImageURL
        self.isVerified = isVerified
        self.verificationStatus = verificationStatus
        self.refFriendName = refFriendName
        self.refFriendRoll = refFriendRoll
        self.refFriendDept = refFriendDept
        self.refFriendBatch = refFriendBatch
        self.averageRating = averageRating
        self.totalReviews = totalReviews
    }
}
