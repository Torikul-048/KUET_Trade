//
//  User.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import Foundation
import FirebaseFirestore

struct KTUser: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String
    var name: String
    var email: String
    var phone: String
    var department: String
    var joinedDate: Date
    var profileImageURL: String?
    
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
        joinedDate: Date = Date(),
        profileImageURL: String? = nil
    ) {
        self.id = id
        self.uid = uid
        self.name = name
        self.email = email
        self.phone = phone
        self.department = department
        self.joinedDate = joinedDate
        self.profileImageURL = profileImageURL
    }
}
