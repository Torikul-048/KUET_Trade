//
//  LaunchScreenView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var logoScale: CGFloat = 0.5
    @State private var logoOpacity: Double = 0
    @State private var taglineOpacity: Double = 0
    @State private var spinnerOpacity: Double = 0
    @State private var universityOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color.accentColor.opacity(0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                
                // Logo icon
                Image(systemName: "storefront.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(Color.accentColor)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                // App name
                Text(AppConstants.appName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(logoOpacity)
                
                // Tagline
                Text(AppConstants.appTagline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .opacity(taglineOpacity)
                
                // Loading indicator
                ProgressView()
                    .controlSize(.regular)
                    .padding(.top, 16)
                    .opacity(spinnerOpacity)
                
                Spacer()
                
                // University badge
                VStack(spacing: 4) {
                    Image(systemName: "building.columns.fill")
                        .font(.caption)
                    Text(AppConstants.universityName)
                        .font(.caption2)
                }
                .foregroundStyle(.tertiary)
                .opacity(universityOpacity)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            // Staggered animation sequence
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.4).delay(0.4)) {
                taglineOpacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.3).delay(0.6)) {
                spinnerOpacity = 1.0
            }
            withAnimation(.easeIn(duration: 0.3).delay(0.8)) {
                universityOpacity = 1.0
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
