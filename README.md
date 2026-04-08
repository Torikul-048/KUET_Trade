# 🎓 KUET Trade — Campus Marketplace iOS App

> A dedicated iOS marketplace for KUET students to securely buy and sell academic essentials and electronics on campus.

![Platform](https://img.shields.io/badge/Platform-iOS%2018.4+-blue)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-orange)
![Firebase](https://img.shields.io/badge/Backend-Firebase-yellow)
![License](https://img.shields.io/badge/License-Academic-green)

---

## 📖 About

**KUET Trade** is a campus-specific marketplace app (like Bikroy/Craigslist) built exclusively for students of **Khulna University of Engineering & Technology (KUET)**. Students can post items they want to sell, browse listings from other students, filter by category or price, and contact sellers directly via phone call or WhatsApp.

### Why KUET Trade?
- 🏫 **Campus-focused** — Only for KUET students
- 📚 **Academic essentials** — Books, electronics, accessories
- 🤝 **Peer-to-peer** — Direct buyer-seller interaction
- 📱 **Native iOS** — Built with SwiftUI for smooth experience
- 🔥 **Real-time** — Powered by Firebase backend

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🔐 **User Authentication** | Email/Password signup & login via Firebase Auth |
| 📝 **Post an Item** | Upload photo (camera/gallery), title, price, description, category |
| 🔍 **Search & Filter** | Search by keyword, filter by category, sort by price |
| 📋 **My Ads Dashboard** | View, edit, delete, and mark-as-sold your own posts |
| 📞 **Contact Seller** | Call or WhatsApp the seller directly from the app |
| 🏷️ **Categories** | Books, Electronics, Accessories, Others |
| 🏫 **Department Tags** | All 18 KUET departments supported |

---

## 🏗️ Tech Stack

| Layer | Technology |
|-------|-----------|
| **UI Framework** | SwiftUI (iOS 18.4+) |
| **Architecture** | MVVM (Model-View-ViewModel) |
| **Authentication** | Firebase Auth (Email/Password) |
| **Database** | Cloud Firestore |
| **Image Storage** | Firebase Storage |
| **Package Manager** | Swift Package Manager (SPM) |
| **IDE** | Xcode 16.3 |

---

## 📁 Project Structure

```
KUET_Trade/
├── KUET_TradeApp.swift              # App entry point + Firebase init
├── ContentView.swift                # Root navigation (Auth gate)
├── GoogleService-Info.plist         # Firebase configuration
│
├── Models/
│   ├── User.swift                   # KTUser model (Firestore Codable)
│   └── Item.swift                   # Item model + ItemCategory enum + SortOption enum
│
├── ViewModels/
│   ├── AuthViewModel.swift          # Login/Signup/Logout state management
│   ├── ItemViewModel.swift          # CRUD + search/filter for items
│   └── ImagePickerViewModel.swift   # Camera/Photo library state
│
├── Views/
│   ├── Auth/
│   │   ├── LoginView.swift          # Login screen
│   │   ├── SignUpView.swift         # Registration screen
│   │   └── ForgotPasswordView.swift # Password reset screen
│   │
│   ├── Home/
│   │   ├── HomeView.swift           # Main feed (browse all items)
│   │   ├── ItemCardView.swift       # Single item card component
│   │   └── ItemDetailView.swift     # Full item detail + contact seller
│   │
│   ├── Post/
│   │   ├── PostItemView.swift       # Create new listing form
│   │   └── EditItemView.swift       # Edit existing listing
│   │
│   ├── Search/
│   │   └── SearchFilterView.swift   # Search bar + filter/sort controls
│   │
│   ├── Profile/
│   │   ├── MyAdsView.swift          # User's own listings dashboard
│   │   └── ProfileView.swift        # User profile + logout
│   │
│   └── Components/
│       ├── ImagePicker.swift        # UIImagePickerController wrapper
│       ├── CategoryPicker.swift     # Category selection component
│       └── ContactSellerButton.swift# Call/WhatsApp buttons
│
├── Services/
│   ├── AuthService.swift            # Firebase Auth wrapper (singleton)
│   ├── FirestoreService.swift       # Firestore CRUD operations (singleton)
│   └── StorageService.swift         # Firebase Storage upload/delete (singleton)
│
├── Utilities/
│   ├── Constants.swift              # App-wide constants & config
│   └── Extensions.swift             # String, View, Date, Double extensions
│
└── Assets.xcassets/                 # App icons, colors, images
```

---

## 🗄️ Firestore Database Schema

### `users` Collection
```
users/{userId}
├── uid: String
├── name: String
├── email: String
├── phone: String
├── department: String (e.g., "CSE", "EEE")
├── joinedDate: Timestamp
└── profileImageURL: String? (optional)
```

### `items` Collection
```
items/{itemId}
├── title: String
├── description: String
├── price: Double
├── category: String ("Books" | "Electronics" | "Accessories" | "Others")
├── imageURLs: [String]
├── sellerID: String (→ users/{userId})
├── sellerName: String
├── sellerPhone: String
├── isAvailable: Bool
├── createdAt: Timestamp
└── updatedAt: Timestamp
```

---

## 📱 App Flow

```
App Launch
    │
    ├── Not Logged In ──→ LoginView
    │                        ├── → SignUpView
    │                        └── → ForgotPasswordView
    │
    └── Logged In ──→ TabView (4 tabs)
                        ├── 🏠 Home (Browse all items)
                        │     ├── Search Bar + Filters
                        │     └── Tap Item → ItemDetailView
                        │                      └── Contact Seller (Call/WhatsApp)
                        │
                        ├── ➕ Post (Create new listing)
                        │     ├── Camera / Photo Library
                        │     ├── Title, Price, Description
                        │     └── Category Picker
                        │
                        ├── 📋 My Ads (Manage your listings)
                        │     ├── Edit → EditItemView
                        │     ├── Delete
                        │     └── Mark as Sold
                        │
                        └── 👤 Profile
                              ├── User Info
                              └── Logout
```

---

## 🔧 Setup Instructions

### Prerequisites
- macOS with **Xcode 16.3+**
- Apple Developer account (for device testing)
- Firebase project ([console.firebase.google.com](https://console.firebase.google.com))

### Step 1: Clone & Open
```bash
cd ~/Desktop
open KUET_Trade/KUET_Trade.xcodeproj
```

### Step 2: Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Register iOS app with bundle ID: `torikul.KUET-Trade`
3. Download `GoogleService-Info.plist` → place in `KUET_Trade/` folder
4. Enable **Email/Password** in Authentication → Sign-in method
5. Create **Firestore Database** (start in test mode)
6. Enable **Firebase Storage** (start in test mode)

### Step 3: Add SPM Dependencies
In Xcode: File → Add Package Dependencies → Add:
- `https://github.com/firebase/firebase-ios-sdk` → Select: `FirebaseAuth`, `FirebaseFirestore`, `FirebaseStorage`
- `https://github.com/nicklama/firebase-storage-combine` (if needed)

### Step 4: Build & Run
- Select iPhone simulator or physical device
- Press `Cmd + R` to build and run

---

## 🔒 Firebase Security Rules (Production)

### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own profile
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    // Items: anyone logged in can read, only owner can write/delete
    match /items/{itemId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.sellerID;
    }
  }
}
```

### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /item_images/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && request.resource.size < 5 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

---

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase-ios-sdk` | Latest | Auth, Firestore, Storage |
| `SDWebImageSwiftUI` | Latest | Async image loading & caching |

---

## 👨‍💻 Developer

| | |
|---|---|
| **Name** | Himel (Torikul) |
| **University** | KUET |
| **Bundle ID** | `torikul.KUET-Trade` |
| **Firebase Project** | `kuet-trade` |

---

## 📄 License

This project is developed for academic purposes at KUET. All rights reserved.

---

## 🗺️ Development Roadmap

See [PROGRESS.md](./PROGRESS.md) for detailed phase-by-phase tracking.

| Phase | Description | Status |
|-------|-------------|--------|
| Phase 1 | Project Setup + Firebase + Models + Services + Utilities | ✅ Done |
| Phase 2 | Authentication (Login/Signup/Logout) Views + ViewModel | ⬜ Next |
| Phase 3 | Home Feed + Item Display | ⬜ Pending |
| Phase 4 | Post & Edit Items | ⬜ Pending |
| Phase 5 | Search & Filter | ⬜ Pending |
| Phase 6 | My Ads Dashboard + Profile | ⬜ Pending |
| Phase 7 | Contact Seller (Call/WhatsApp) | ⬜ Pending |
| Phase 8 | Polish & Final Touches | ⬜ Pending |
