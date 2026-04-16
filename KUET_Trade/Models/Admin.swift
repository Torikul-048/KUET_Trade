//
//  Admin.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseFirestore

struct AdminUser: Identifiable, Codable {
    @DocumentID var id: String?
    var uid: String
    var email: String
    var name: String
    var role: String

    init(id: String? = nil, uid: String, email: String, name: String, role: String = "moderator") {
        self.id = id
        self.uid = uid
        self.email = email
        self.name = name
        self.role = role
    }
}
