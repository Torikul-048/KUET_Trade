//
//  ContentView.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel.shared
    
    var body: some View {
        Group {
            if viewModel.isCheckingAuth {
                LaunchScreenView()
            } else if let user = viewModel.currentUser {
                if user.isVerified {
                    MainTabView(authViewModel: viewModel)
                } else if user.verificationStatus == .rejected {
                    RejectedAccountView(onSignOut: {
                        viewModel.signOut()
                    })
                } else {
                    PendingVerificationView(onSignOut: {
                        viewModel.signOut()
                    })
                }
            } else {
                LoginView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
