//
//  Constants.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import Foundation
import SwiftUI

struct AppConstants {
    
    // MARK: - App Info
    static let appName = "KUET Trade"
    static let appTagline = "Buy & Sell on Campus"
    static let universityName = "Khulna University of Engineering & Technology"
    
    // MARK: - Firestore Collections
    struct Collections {
        static let users = "users"
        static let items = "items"
    }
    
    // MARK: - Storage Paths
    struct StoragePaths {
        static let itemImages = "item_images"
        static let profileImages = "profile_images"
    }
    
    // MARK: - Departments at KUET
    static let departments: [String] = [
        "CSE",
        "EEE",
        "ME",
        "CE",
        "ECE",
        "IEM",
        "BECM",
        "URP",
        "Textile",
        "Leather",
        "Chemistry",
        "Physics",
        "Mathematics",
        "Humanities",
        "Energy Technology",
        "Biomedical Engineering",
        "Materials Science & Engineering",
        "Other"
    ]
    
    // MARK: - Validation
    struct Validation {
        static let minPasswordLength = 6
        static let maxTitleLength = 80
        static let maxDescriptionLength = 500
        static let maxPrice: Double = 999999
        static let maxImages = 3
    }
    
    // MARK: - App Colors
    struct Colors {
        static let primary = Color("AccentColor")
        static let background = Color(.systemGroupedBackground)
        static let cardBackground = Color(.secondarySystemGroupedBackground)
        static let secondaryText = Color(.secondaryLabel)
    }
}
