//
//  Constants.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
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
        static let reviews = "reviews"
        static let buyRequests = "buyRequests"
        static let conversations = "conversations"
        static let messages = "messages"
    }
    
    // MARK: - Storage Paths
    struct StoragePaths {
        static let itemImages = "item_images"
        static let profileImages = "profile_images"
    }

    // MARK: - Cloudinary
    struct Cloudinary {
        static let cloudName = "dxmacan3v"
        static let uploadPreset = "kuet_trade_preset"
        static let defaultFolder = "kuet_trade"
    }

    // MARK: - Currency API
    struct Currency {
        static let baseURL = "https://open.er-api.com/v6/latest"
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
