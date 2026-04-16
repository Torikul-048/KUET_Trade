//
//  AuthService.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    static let shared = AuthService()
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Get Current User ID
    var currentUserID: String? {
        return auth.currentUser?.uid
    }
    
    var isLoggedIn: Bool {
        return auth.currentUser != nil
    }
    
    // MARK: - Sign Up
    func signUp(
        name: String,
        email: String,
        phone: String,
        department: String,
        roll: String,
        batch: String,
        refFriendName: String,
        refFriendRoll: String,
        refFriendDept: String,
        refFriendBatch: String,
        password: String
    ) async throws -> KTUser {
        let result = try await auth.createUser(withEmail: email, password: password)
        let uid = result.user.uid
        
        let newUser = KTUser(
            uid: uid,
            name: name,
            email: email,
            phone: phone,
            department: department,
            roll: roll,
            batch: batch,
            joinedDate: Date(),
            isVerified: false,
            verificationStatus: .pending,
            refFriendName: refFriendName,
            refFriendRoll: refFriendRoll,
            refFriendDept: refFriendDept,
            refFriendBatch: refFriendBatch
        )
        
        try db.collection("users").document(uid).setData(from: newUser)
        return newUser
    }
    
    // MARK: - Sign In
    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }
    
    // MARK: - Sign Out
    func signOut() throws {
        try auth.signOut()
    }
    
    // MARK: - Reset Password
    func resetPassword(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Fetch Current User Data from Firestore
    func fetchCurrentUser() async throws -> KTUser? {
        guard let uid = currentUserID else { return nil }
        let userRef = db.collection("users").document(uid)
        let snapshot = try await userRef.getDocument()

        guard snapshot.exists else { return nil }
        let data = snapshot.data() ?? [:]

        // Legacy users (created before verification rollout) should remain accepted.
        let hasIsVerified = data["isVerified"] != nil
        let hasVerificationStatus = data["verificationStatus"] != nil

        let verificationStatus: VerificationStatus = {
            guard let raw = data["verificationStatus"] as? String,
                  let status = VerificationStatus(rawValue: raw) else {
                return .approved
            }
            return status
        }()

        let isVerified = (data["isVerified"] as? Bool) ?? (verificationStatus == .approved)

        if !hasIsVerified || !hasVerificationStatus {
            try? await userRef.setData([
                "isVerified": true,
                "verificationStatus": VerificationStatus.approved.rawValue
            ], merge: true)
        }

        let joinedDate: Date = {
            if let timestamp = data["joinedDate"] as? Timestamp {
                return timestamp.dateValue()
            }
            if let date = data["joinedDate"] as? Date {
                return date
            }
            return Date()
        }()

        let firebaseUser = auth.currentUser

        return KTUser(
            id: snapshot.documentID,
            uid: (data["uid"] as? String) ?? uid,
            name: (data["name"] as? String) ?? firebaseUser?.displayName ?? "User",
            email: (data["email"] as? String) ?? firebaseUser?.email ?? "",
            phone: (data["phone"] as? String) ?? firebaseUser?.phoneNumber ?? "",
            department: (data["department"] as? String) ?? "",
            roll: (data["roll"] as? String) ?? "",
            batch: (data["batch"] as? String) ?? "",
            joinedDate: joinedDate,
            profileImageURL: data["profileImageURL"] as? String,
            isVerified: isVerified,
            verificationStatus: verificationStatus,
            refFriendName: (data["refFriendName"] as? String) ?? "",
            refFriendRoll: (data["refFriendRoll"] as? String) ?? "",
            refFriendDept: (data["refFriendDept"] as? String) ?? "",
            refFriendBatch: (data["refFriendBatch"] as? String) ?? "",
            averageRating: data["averageRating"] as? Double,
            totalReviews: data["totalReviews"] as? Int
        )
    }

    // MARK: - Admin Check
    func isAdmin(uid: String) async throws -> Bool {
        let snapshot = try await db.collection("admins").document(uid).getDocument()
        return snapshot.exists
    }

    func isCurrentUserAdmin() async throws -> Bool {
        guard let uid = currentUserID else { return false }
        return try await isAdmin(uid: uid)
    }
    
    // MARK: - Auth State Listener
    func addAuthStateListener(completion: @escaping (Bool) -> Void) -> AuthStateDidChangeListenerHandle {
        return auth.addStateDidChangeListener { _, user in
            completion(user != nil)
        }
    }
    
    func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle) {
        auth.removeStateDidChangeListener(handle)
    }
}
