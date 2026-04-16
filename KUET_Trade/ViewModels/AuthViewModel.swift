//
//  AuthViewModel.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    
    // MARK: - Shared Instance
    static let shared = AuthViewModel()
    
    // MARK: - Auth State
    @Published var isLoggedIn: Bool = false
    @Published var isCheckingAuth: Bool = true
    @Published var currentUser: KTUser?
    
    // MARK: - Login Fields
    @Published var loginEmail: String = ""
    @Published var loginPassword: String = ""
    
    // MARK: - Signup Fields
    @Published var signupName: String = ""
    @Published var signupEmail: String = ""
    @Published var signupPhone: String = ""
    @Published var signupDepartment: String = ""
    @Published var signupRoll: String = ""
    @Published var signupBatch: String = ""
    @Published var refFriendName: String = ""
    @Published var refFriendRoll: String = ""
    @Published var refFriendDept: String = ""
    @Published var refFriendBatch: String = ""
    @Published var signupPassword: String = ""
    @Published var signupConfirmPassword: String = ""
    
    // MARK: - Forgot Password Fields
    @Published var resetEmail: String = ""
    @Published var resetEmailSent: Bool = false
    
    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    
    // MARK: - Auth Listener
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    // MARK: - Init
    init() {
        listenToAuthState()
    }
    
    deinit {
        if let handle = authListenerHandle {
            AuthService.shared.removeAuthStateListener(handle)
        }
    }
    
    // MARK: - Auth State Listener
    private func listenToAuthState() {
        authListenerHandle = AuthService.shared.addAuthStateListener { [weak self] loggedIn in
            Task { @MainActor in
                self?.isLoggedIn = loggedIn
                self?.isCheckingAuth = false
                
                if loggedIn {
                    await self?.fetchUser()
                } else {
                    self?.currentUser = nil
                }
            }
        }
    }
    
    // MARK: - Fetch Current User
    func fetchUser() async {
        do {
            currentUser = try await AuthService.shared.fetchCurrentUser()
        } catch {
            // Fallback: build user from Firebase Auth if Firestore fails
            if let firebaseUser = Auth.auth().currentUser {
                currentUser = KTUser(
                    uid: firebaseUser.uid,
                    name: firebaseUser.displayName ?? firebaseUser.email?.components(separatedBy: "@").first ?? "User",
                    email: firebaseUser.email ?? "—",
                    phone: firebaseUser.phoneNumber ?? "—",
                    department: "",
                    joinedDate: firebaseUser.metadata.creationDate ?? Date()
                )
            }
            print("⚠️ Failed to load profile from Firestore: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Login
    func login() async {
        // Validate
        guard validateLoginFields() else { return }
        
        isLoading = true
        do {
            try await AuthService.shared.signIn(
                email: loginEmail.trimmed,
                password: loginPassword
            )
            clearLoginFields()
        } catch {
            showErrorMessage(mapAuthError(error))
        }
        isLoading = false
    }
    
    // MARK: - Sign Up
    func signUp() async {
        // Validate
        guard validateSignupFields() else { return }
        
        isLoading = true
        do {
            let user = try await AuthService.shared.signUp(
                name: signupName.trimmed,
                email: signupEmail.trimmed,
                phone: signupPhone.trimmed,
                department: signupDepartment,
                roll: signupRoll.trimmed,
                batch: signupBatch,
                refFriendName: refFriendName.trimmed,
                refFriendRoll: refFriendRoll.trimmed,
                refFriendDept: refFriendDept,
                refFriendBatch: refFriendBatch,
                password: signupPassword
            )
            currentUser = user
            clearSignupFields()
        } catch {
            showErrorMessage(mapAuthError(error))
        }
        isLoading = false
    }
    
    // MARK: - Forgot Password
    func resetPassword() async {
        let email = resetEmail.trimmed
        
        guard !email.isEmpty else {
            showErrorMessage("Please enter your email address.")
            return
        }
        guard email.isValidEmail else {
            showErrorMessage("Please enter a valid email address.")
            return
        }
        
        isLoading = true
        do {
            try await AuthService.shared.resetPassword(email: email)
            resetEmailSent = true
        } catch {
            showErrorMessage(mapAuthError(error))
        }
        isLoading = false
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try AuthService.shared.signOut()
            currentUser = nil
            clearLoginFields()
            clearSignupFields()
        } catch {
            showErrorMessage("Failed to sign out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Login Validation
    private func validateLoginFields() -> Bool {
        let email = loginEmail.trimmed
        let password = loginPassword
        
        if email.isEmpty || password.isEmpty {
            showErrorMessage("Please fill in all fields.")
            return false
        }
        if !email.isValidEmail {
            showErrorMessage("Please enter a valid email address.")
            return false
        }
        if password.count < AppConstants.Validation.minPasswordLength {
            showErrorMessage("Password must be at least \(AppConstants.Validation.minPasswordLength) characters.")
            return false
        }
        return true
    }
    
    // MARK: - Signup Validation
    private func validateSignupFields() -> Bool {
        let name = signupName.trimmed
        let email = signupEmail.trimmed
        let phone = signupPhone.trimmed
        let department = signupDepartment
        let roll = signupRoll.trimmed
        let batch = signupBatch
        let friendName = refFriendName.trimmed
        let friendRoll = refFriendRoll.trimmed
        let friendDept = refFriendDept
        let friendBatch = refFriendBatch
        let password = signupPassword
        let confirmPassword = signupConfirmPassword
        
        if name.isEmpty || email.isEmpty || phone.isEmpty || department.isEmpty || roll.isEmpty || batch.isEmpty || friendName.isEmpty || friendRoll.isEmpty || friendDept.isEmpty || friendBatch.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showErrorMessage("Please fill in all fields.")
            return false
        }
        if !email.isValidEmail {
            showErrorMessage("Please enter a valid email address.")
            return false
        }
        if !phone.isValidPhone {
            showErrorMessage("Please enter a valid phone number (10–14 digits).")
            return false
        }
        if !roll.allSatisfy({ $0.isNumber }) {
            showErrorMessage("Roll number must contain digits only.")
            return false
        }
        if !friendRoll.allSatisfy({ $0.isNumber }) {
            showErrorMessage("Reference roll number must contain digits only.")
            return false
        }
        if password.count < AppConstants.Validation.minPasswordLength {
            showErrorMessage("Password must be at least \(AppConstants.Validation.minPasswordLength) characters.")
            return false
        }
        if password != confirmPassword {
            showErrorMessage("Passwords do not match.")
            return false
        }
        return true
    }
    
    // MARK: - Error Helpers
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func mapAuthError(_ error: Error) -> String {
        let nsError = error as NSError
        
        guard nsError.domain == AuthErrorDomain else {
            return error.localizedDescription
        }
        
        switch AuthErrorCode(rawValue: nsError.code) {
        case .invalidEmail:
            return "The email address is invalid."
        case .emailAlreadyInUse:
            return "This email is already registered. Try logging in."
        case .weakPassword:
            return "Password is too weak. Use at least 6 characters."
        case .wrongPassword, .invalidCredential:
            return "Incorrect email or password."
        case .userNotFound:
            return "No account found with this email."
        case .userDisabled:
            return "This account has been disabled."
        case .networkError:
            return "Network error. Please check your connection."
        case .tooManyRequests:
            return "Too many attempts. Please try again later."
        default:
            return error.localizedDescription
        }
    }
    
    // MARK: - Clear Fields
    private func clearLoginFields() {
        loginEmail = ""
        loginPassword = ""
    }
    
    private func clearSignupFields() {
        signupName = ""
        signupEmail = ""
        signupPhone = ""
        signupDepartment = ""
        signupRoll = ""
        signupBatch = ""
        refFriendName = ""
        refFriendRoll = ""
        refFriendDept = ""
        refFriendBatch = ""
        signupPassword = ""
        signupConfirmPassword = ""
    }
    
    func clearResetFields() {
        resetEmail = ""
        resetEmailSent = false
    }
}
