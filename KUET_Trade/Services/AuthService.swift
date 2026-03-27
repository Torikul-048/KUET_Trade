//
//  AuthService.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
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
    func signUp(name: String, email: String, phone: String, department: String, password: String) async throws -> KTUser {
        let result = try await auth.createUser(withEmail: email, password: password)
        let uid = result.user.uid
        
        // Save display name to Firebase Auth profile
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
        
        let newUser = KTUser(
            uid: uid,
            name: name,
            email: email,
            phone: phone,
            department: department,
            joinedDate: Date()
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
        let snapshot = try await db.collection("users").document(uid).getDocument()
        return try snapshot.data(as: KTUser.self)
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
