//
//  MainTabView.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @StateObject private var itemViewModel = ItemViewModel()
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @State private var selectedTab: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Offline banner
            OfflineBannerView()
                .animation(.easeInOut(duration: 0.3), value: networkMonitor.isConnected)
            
            TabView(selection: $selectedTab) {
                HomeView(itemViewModel: itemViewModel)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)

                BuyRequestsListView()
                    .tabItem {
                        Label("Requests", systemImage: "hand.raised.fill")
                    }
                    .tag(1)

                ConversationsListView()
                    .tabItem {
                        Label("Messages", systemImage: "bubble.left.and.bubble.right.fill")
                    }
                    .tag(2)
                
                PostItemView(itemViewModel: itemViewModel)
                    .tabItem {
                        Label("Post", systemImage: "plus.circle.fill")
                    }
                    .tag(3)
                
                MyAdsView(authViewModel: authViewModel, itemViewModel: itemViewModel)
                    .tabItem {
                        Label("My Ads", systemImage: "rectangle.stack.fill")
                    }
                    .tag(4)
                
                ProfileView(authViewModel: authViewModel)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
                    .tag(5)
            }
            .tint(Color.kuetGreen)
            .toolbarBackground(Color(.systemBackground), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .onChange(of: selectedTab) { _, _ in
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            }
        }
    }
}

// MARK: - Placeholder Tab View (for future phases)
struct PlaceholderTabView: View {
    let icon: String
    let title: String
    let subtitle: String
    var showSignOut: Bool = false
    var onSignOut: (() -> Void)? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundStyle(.secondary)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if showSignOut, let onSignOut = onSignOut {
                    Button("Sign Out") {
                        onSignOut()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .padding(.top, 12)
                }
                
                Spacer()
            }
            .navigationTitle(title)
        }
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
}
