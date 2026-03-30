//
//  ContactSellerButton.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI

// MARK: - Contact Method Enum
enum ContactMethod: String, CaseIterable, Identifiable {
    case call = "Call"
    case whatsApp = "WhatsApp"
    case sms = "SMS"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .call: return "phone.fill"
        case .whatsApp: return "message.fill"
        case .sms: return "bubble.left.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .call: return .accentColor
        case .whatsApp: return .green
        case .sms: return .blue
        }
    }
    
    var label: String {
        switch self {
        case .call: return "Call Seller"
        case .whatsApp: return "WhatsApp"
        case .sms: return "SMS"
        }
    }
}

// MARK: - Contact Seller Buttons (Full Width Stack)
struct ContactSellerButtons: View {
    let phone: String
    let itemTitle: String
    
    var body: some View {
        VStack(spacing: 10) {
            // Call Button — full width
            ContactSellerButton(method: .call, phone: phone, itemTitle: itemTitle, style: .full)
            
            // WhatsApp + SMS side by side
            HStack(spacing: 10) {
                ContactSellerButton(method: .whatsApp, phone: phone, itemTitle: itemTitle, style: .full)
                ContactSellerButton(method: .sms, phone: phone, itemTitle: itemTitle, style: .full)
            }
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
        case .whatsApp:
            openWhatsApp(phone: cleaned)
        case .sms:
            openSMS(phone: cleaned)
        }
    }
    
    // MARK: - Clean Phone
    private var cleanedPhone: String {
        phone.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
    
    // MARK: - International Format
    private func internationalPhone(_ phone: String) -> String {
        var p = phone
        if p.hasPrefix("0") {
            p = "+88" + p
        } else if !p.hasPrefix("+") {
            p = "+88" + p
        }
        return p
    }
    
    // MARK: - Call
    private func openCall(phone: String) {
        if let url = URL(string: "tel://\(phone)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                showUnavailableAlert = true
            }
        }
    }
    
    // MARK: - WhatsApp
    private func openWhatsApp(phone: String) {
        let intlPhone = internationalPhone(phone)
        let message = "Hi! I'm interested in your listing: \"\(itemTitle)\" on KUET Trade."
        let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "https://wa.me/\(intlPhone)?text=\(encoded)") {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - SMS
    private func openSMS(phone: String) {
        let message = "Hi! I'm interested in your listing: \"\(itemTitle)\" on KUET Trade."
        let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "sms:\(phone)&body=\(encoded)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                showUnavailableAlert = true
            }
        }
    }
    
    // MARK: - Unavailable Message
    private var unavailableMessage: String {
        switch method {
        case .call:
            return "Phone calls are not available on this device."
        case .whatsApp:
            return "Could not open WhatsApp. Make sure it is installed."
        case .sms:
            return "SMS is not available on this device."
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
                    
                    HStack(spacing: 10) {
                        ContactSellerButton(method: .whatsApp, phone: item.sellerPhone, itemTitle: item.title, style: .full)
                        ContactSellerButton(method: .sms, phone: item.sellerPhone, itemTitle: item.title, style: .full)
                    }
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
        sellerName: "Himel Rahman",
        sellerPhone: "01712345678"
    ))
}
