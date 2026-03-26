//
//  ContentView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isCheckingAuth {
                // Animated Splash / Launch Screen
                LaunchScreenView()
            } else if authViewModel.isLoggedIn {
                MainTabView(authViewModel: authViewModel)
            } else {
                LoginView(viewModel: authViewModel)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: authViewModel.isLoggedIn)
        .animation(.easeInOut(duration: 0.4), value: authViewModel.isCheckingAuth)
    }
}

#Preview {
    ContentView()
}
