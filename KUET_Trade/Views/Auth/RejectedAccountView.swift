//
//  RejectedAccountView.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import SwiftUI

struct RejectedAccountView: View {
    var onSignOut: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "xmark.octagon.fill")
                .font(.system(size: 56))
                .foregroundStyle(.red)

            Text("Verification Rejected")
                .font(.title2)
                .fontWeight(.bold)

            Text("Your account verification request was rejected. Please contact support or register again with valid details.")
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
    RejectedAccountView()
}
