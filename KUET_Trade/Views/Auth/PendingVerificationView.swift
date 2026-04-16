//
//  PendingVerificationView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct PendingVerificationView: View {
    var onSignOut: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.badge.questionmark.fill")
                .font(.system(size: 56))
                .foregroundStyle(.orange)

            Text("Verification Pending")
                .font(.title2)
                .fontWeight(.bold)

            Text("Your account is under review by an admin. Please check back later.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)

            if let onSignOut {
                Button("Sign Out") {
                    onSignOut()
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.top, 8)
            }
        }
        .padding()
    }
}

#Preview {
    PendingVerificationView()
}
