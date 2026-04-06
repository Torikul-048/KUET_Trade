//
//  ProfileView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showSignOutConfirm: Bool = false
    @State private var showShareSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    // MARK: - Profile Header
                    Section {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color.accentColor.opacity(0.15))
                                    .frame(width: 70, height: 70)
                                
                                Text(authViewModel.currentUser?.initials ?? "?")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color.accentColor)
                            }
                            
                            Text(authViewModel.currentUser?.name ?? "User")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            if let dept = authViewModel.currentUser?.department, !dept.isEmpty {
                                Text(dept)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.1))
                                    .foregroundStyle(Color.accentColor)
                                    .cornerRadius(12)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    
                    // MARK: - Info
                    Section("Information") {
                        Label(authViewModel.currentUser?.email ?? "—", systemImage: "envelope.fill")
                            .font(.subheadline)
                        
                        Label(authViewModel.currentUser?.phone ?? "—", systemImage: "phone.fill")
                            .font(.subheadline)
                        
                        if let dept = authViewModel.currentUser?.department, !dept.isEmpty {
                            Label(dept, systemImage: "building.2.fill")
                                .font(.subheadline)
                        }
                        
                        Label(authViewModel.currentUser?.joinedDate.formattedString ?? "—", systemImage: "calendar")
                            .font(.subheadline)
                    }
                    
                    // MARK: - Actions
                    Section {
                        Button {
                            showShareSheet = true
                        } label: {
                            Label("Share App", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                // MARK: - Fixed Sign Out Button at Bottom
                VStack(spacing: 8) {
                    Button(role: .destructive) {
                        showSignOutConfirm = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.red.opacity(0.1))
                        .foregroundStyle(.red)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Text("KUET Trade v\(appVersion)")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
                .padding(.vertical, 10)
                .background(Color(.systemGroupedBackground))
            }
            .navigationTitle("Profile")
            .confirmationDialog("Sign Out", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
                Button("Sign Out", role: .destructive) {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                    authViewModel.signOut()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: [
                    "Check out \(AppConstants.appName) — \(AppConstants.appTagline)! The marketplace app for KUET students. 🎓"
                ])
            }
        }
    }
    
    // MARK: - App Version
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

// MARK: - Share Sheet (UIActivityViewController wrapper)
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ProfileView(authViewModel: AuthViewModel())
}
