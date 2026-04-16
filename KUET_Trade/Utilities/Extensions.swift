//
//  Extensions.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import Foundation
import SwiftUI

// MARK: - String Validation Extensions
extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var isValidPhone: Bool {
        let regex = "^[0-9+]{10,14}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - View Extensions
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func cardStyle() -> some View {
        self
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Date Extensions
extension Date {
    var formattedString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

// MARK: - Double Extensions
extension Double {
    var formattedAsTaka: String {
        return "৳\(String(format: "%.0f", self))"
    }
}
