//
//  AdminService.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AdminService {
    static let shared = AdminService()

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    private init() {}

    // MARK: - Authentication
    func signIn(email: String, password: String) async throws {
        let result = try await auth.signIn(withEmail: email, password: password)
        let isAdmin = try await AuthService.shared.isAdmin(uid: result.user.uid)

        guard isAdmin else {
            try auth.signOut()
            throw AdminServiceError.notAuthorized
        }
    }

    func signOut() {
        try? auth.signOut()
    }

    // MARK: - Users
    func fetchPendingUsers() async throws -> [KTUser] {
        let snapshot = try await db.collection(AppConstants.Collections.users)
            .whereField("verificationStatus", isEqualTo: VerificationStatus.pending.rawValue)
            .order(by: "joinedDate", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: KTUser.self) }
    }

    func fetchAllUsers() async throws -> [KTUser] {
        let snapshot = try await db.collection(AppConstants.Collections.users)
            .order(by: "joinedDate", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: KTUser.self) }
    }

    func approveUser(_ user: KTUser) async throws {
        guard let id = user.id else { throw AdminServiceError.missingUserID }

        try await db.collection(AppConstants.Collections.users).document(id).updateData([
            "isVerified": true,
            "verificationStatus": VerificationStatus.approved.rawValue
        ])
    }

    func rejectUser(_ user: KTUser) async throws {
        guard let id = user.id else { throw AdminServiceError.missingUserID }

        try await db.collection(AppConstants.Collections.users).document(id).updateData([
            "isVerified": false,
            "verificationStatus": VerificationStatus.rejected.rawValue
        ])
    }

    func deleteUserData(_ user: KTUser) async throws {
        guard let userDocID = user.id else { throw AdminServiceError.missingUserID }

        let itemsSnapshot = try await db.collection(AppConstants.Collections.items)
            .whereField("sellerID", isEqualTo: user.uid)
            .getDocuments()

        for doc in itemsSnapshot.documents {
            try await doc.reference.delete()
        }

        try await db.collection(AppConstants.Collections.users).document(userDocID).delete()

        try await db.collection("deletedUsers").document(userDocID).setData([
            "uid": user.uid,
            "email": user.email,
            "deletedAt": FieldValue.serverTimestamp(),
            "reason": "Admin deletion"
        ])
    }
}

enum AdminServiceError: LocalizedError {
    case notAuthorized
    case missingUserID

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "You are not authorized as an admin."
        case .missingUserID:
            return "Missing user ID."
        }
    }
}
