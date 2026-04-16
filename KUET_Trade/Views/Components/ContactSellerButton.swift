//
//  ContactSellerButton.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import SwiftUI

// MARK: - Contact Method Enum
enum ContactMethod: String, CaseIterable, Identifiable {
    case call = "Call"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .call: return "phone.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .call: return .accentColor
        }
    }
    
    var label: String {
        switch self {
        case .call: return "Call Seller"
        }
    }
}

// MARK: - Contact Seller Buttons (Full Width Stack)
struct ContactSellerButtons: View {
    let phone: String
    let itemTitle: String
    
    var body: some View {
        VStack(spacing: 10) {
            ContactSellerButton(method: .call, phone: phone, itemTitle: itemTitle, style: .full)
        }
    }
}

// MARK: - Contact Seller Compact Row (for card use)
struct ContactSellerCompactRow: View {
    let phone: String
    let itemTitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(ContactMethod.allCases) { method in
                ContactSellerButton(method: method, phone: phone, itemTitle: itemTitle, style: .compact)
            }
        }
    }
}

// MARK: - Single Contact Seller Button
struct ContactSellerButton: View {
    let method: ContactMethod
    let phone: String
    let itemTitle: String
    let style: ButtonStyle
    
    enum ButtonStyle {
        case full
        case compact
    }
    
    @State private var showUnavailableAlert = false
    
    var body: some View {
        Button {
            performAction()
        } label: {
            Group {
                switch style {
                case .full:
                    fullLabel
                case .compact:
                    compactLabel
                }
            }
        }
        .alert("Cannot Open", isPresented: $showUnavailableAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(unavailableMessage)
        }
    }
    
    // MARK: - Full Label
    private var fullLabel: some View {
        HStack(spacing: 8) {
            Image(systemName: method.icon)
            Text(method.label)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(method.color)
        .foregroundStyle(.white)
        .cornerRadius(12)
    }
    
    // MARK: - Compact Label
    private var compactLabel: some View {
        VStack(spacing: 4) {
            Image(systemName: method.icon)
                .font(.title3)
            Text(method.label)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(method.color.opacity(0.12))
        .foregroundStyle(method.color)
        .cornerRadius(10)
    }
    
    // MARK: - Action
    private func performAction() {
        let cleaned = cleanedPhone
        
        switch method {
        case .call:
            openCall(phone: cleaned)
        }
    }
    
    // MARK: - Clean Phone
    private var cleanedPhone: String {
        phone.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
    
    // MARK: - Call
    private func openCall(phone: String) {
        guard let url = URL(string: "tel:\(phone)") else {
            showUnavailableAlert = true
            return
        }
        UIApplication.shared.open(url) { success in
            if !success {
                showUnavailableAlert = true
            }
        }
    }
    
    // MARK: - Unavailable Message
    private var unavailableMessage: String {
        switch method {
        case .call:
            return "Phone calls are not available on this device."
        }
    }
}

// MARK: - Contact Seller Sheet
struct ContactSellerSheet: View {
    let item: Item
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Seller info header
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.accentColor.opacity(0.15))
                            .frame(width: 64, height: 64)
                        
                        Text(sellerInitials)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.accentColor)
                    }
                    
                    Text(item.sellerName)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                            .font(.caption2)
                        Text(item.sellerPhone)
                            .font(.subheadline)
                    }
                    .foregroundStyle(.secondary)
                }
                .padding(.top, 8)
                
                Divider()
                
                // Item being contacted about
                HStack(spacing: 12) {
                    if let firstURL = item.imageURLs.first, let url = URL(string: firstURL) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure, .empty:
                                Color(.systemGray5)
                                    .overlay {
                                        Image(systemName: "photo")
                                            .foregroundStyle(.secondary)
                                    }
                            @unknown default:
                                Color(.systemGray5)
                            }
                        }
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Contacting about:")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(item.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Text(item.formattedPrice)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
                .padding(.horizontal)
                
                // Contact buttons
                VStack(spacing: 10) {
                    ContactSellerButton(method: .call, phone: item.sellerPhone, itemTitle: item.title, style: .full)
                }
                .padding(.horizontal)
                
                // Safety notice
                HStack(spacing: 6) {
                    Image(systemName: "shield.checkered")
                        .font(.caption)
                    Text("Meet in a safe, public place on campus for exchanges.")
                        .font(.caption)
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Contact Seller")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var sellerInitials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: item.sellerName) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return String(item.sellerName.prefix(2)).uppercased()
    }
}

#Preview("Full Buttons") {
    ContactSellerButtons(phone: "01712345678", itemTitle: "CLRS Textbook")
        .padding()
}

#Preview("Compact Row") {
    ContactSellerCompactRow(phone: "01712345678", itemTitle: "CLRS Textbook")
        .padding()
}

#Preview("Contact Sheet") {
    ContactSellerSheet(item: Item(
        id: "1",
        title: "Data Structures Textbook",
        description: "Good condition",
        price: 450,
        category: .books,
        imageURLs: [],
        sellerID: "abc",
        sellerName: "Torikul Rahman",
        sellerPhone: "01712345678"
    ))
}
