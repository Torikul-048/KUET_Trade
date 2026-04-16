# 🎓 KUET Trade — Campus Marketplace iOS App v2.0

> A comprehensive iOS marketplace for KUET students to buy, sell, and exchange academic essentials and electronics on campus — with admin verification, real-time messaging, reviews, and multi-currency support.

![Platform](https://img.shields.io/badge/Platform-iOS%2018.4+-blue)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-orange)
![Firebase](https://img.shields.io/badge/Backend-Firebase-yellow)
![Cloudinary](https://img.shields.io/badge/Media-Cloudinary-blue)
![License](https://img.shields.io/badge/License-Academic-green)

---

## 📖 About

**KUET Trade v2.0** is an advanced campus-specific marketplace app built exclusively for students of **Khulna University of Engineering & Technology (KUET)**. It's a complete buying/selling/exchanging ecosystem with seller verification, ratings, real-time messaging, and international currency support.

### Why KUET Trade v2.0?

- 🏫 **Campus-focused** — Exclusively for KUET students with verification system
- 📚 **Complete Marketplace** — Buy, sell, and post reverse buy requests (want-to-buy)
- 🔒 **Verified Sellers** — Admin verification system for trusted trades
- ⭐ **Reviews & Ratings** — Trust-based system to ensure quality transactions
- 💬 **Real-time Messaging** — In-app chat between buyers and sellers
- 🌐 **Multi-Currency** — Live currency conversion (BDT ↔ USD/EUR/etc.)
- ☁️ **Cloud Media** — Cloudinary integration for reliable image uploads
- 📱 **Native iOS** — SwiftUI + MVVM architecture
- 🔥 **Real-time** — Firebase Firestore + Storage backend

---

## ✨ Core Features

### 🔐 Authentication & Verification

| Feature                       | Description                                              |
| ----------------------------- | -------------------------------------------------------- |
| **Email/Password Auth**       | Secure signup & login via Firebase Auth                  |
| **Admin Verification Panel**  | Admin dashboard to approve/reject new sellers            |
| **Pending Verification Flow** | Users see status after signup; can view rejection reason |
| **Trust Status Display**      | User profiles show verified badge                        |
| **Department Tags**           | All 18 KUET departments supported during registration    |

### 🛒 Buying & Selling

| Feature                      | Description                                                                  |
| ---------------------------- | ---------------------------------------------------------------------------- |
| **Post Items for Sale**      | Upload photos (cloud-based), title, price, description, category, department |
| **Post Buy Requests**        | Reverse posting — "Looking for X item" with details and price range          |
| **Browse Marketplace**       | Real-time feed of all available items from verified sellers                  |
| **Advanced Search & Filter** | Search by keyword, filter by category/department, sort by price/date         |
| **Item Details**             | Full item view with seller info, trust status, reviews, and contact options  |
| **My Ads Dashboard**         | Manage your listings — edit, delete, mark as sold, repost                    |

### ⭐ Reviews & Trust System

| Feature                    | Description                                            |
| -------------------------- | ------------------------------------------------------ |
| **Star Rating System**     | Leave 1-5 star reviews after transactions              |
| **Written Reviews**        | Add detailed feedback and comments                     |
| **Seller Profile Ratings** | Average rating displayed on user profiles and listings |
| **Trust Badge**            | Verified sellers shown with badge across the app       |
| **Review History**         | Browse all reviews for a seller before buying          |

### 💬 In-App Messaging

| Feature               | Description                                                       |
| --------------------- | ----------------------------------------------------------------- |
| **Real-time Chat**    | Message buyers/sellers without exposing contact details initially |
| **Conversation List** | View all active conversations with unread count                   |
| **Message Status**    | See read/unread status of your messages                           |
| **User Avatars**      | Display seller/buyer profile pictures in chat                     |
| **Typing Indicators** | Know when someone is typing (optional)                            |

### 🌐 International Currency Support

| Feature                    | Description                                  |
| -------------------------- | -------------------------------------------- |
| **Live Exchange Rates**    | Fetch current BDT/USD/EUR/GBP rates from API |
| **Auto Conversion**        | Display item prices in selected currency     |
| **Multi-Currency Display** | Show both BDT and converted amounts          |
| **User Preference**        | Remember selected currency across sessions   |

### 🎨 UI/UX Polish

| Feature               | Description                                       |
| --------------------- | ------------------------------------------------- |
| **Responsive Design** | Optimized for all iPhone sizes (Pro, Pro Max, SE) |
| **Shimmer Loading**   | Skeleton screens for better perceived performance |
| **Image Caching**     | SDWebImage for fast image loading and caching     |
| **Tab Navigation**    | 4-tab interface (Browse, Post, My Ads, Profile)   |
| **Dark Mode Support** | Full dark mode compatibility                      |

### 📸 Media Management

| Feature                    | Description                                             |
| -------------------------- | ------------------------------------------------------- |
| **Cloudinary Integration** | Reliable cloud-based image storage and CDN              |
| **Camera & Photo Library** | Pick images from device camera or gallery               |
| **Multiple Image Upload**  | Upload up to 5 images per listing                       |
| **Image Optimization**     | Automatic compression and transformation via Cloudinary |
| **Fallback Storage**       | Firebase Storage as backup for critical images          |

---

## 🏗️ Tech Stack

| Layer               | Technology                                            |
| ------------------- | ----------------------------------------------------- |
| **UI Framework**    | SwiftUI (iOS 18.4+)                                   |
| **Architecture**    | MVVM (Model-View-ViewModel)                           |
| **Authentication**  | Firebase Auth (Email/Password)                        |
| **Database**        | Cloud Firestore (Real-time)                           |
| **File Storage**    | Firebase Storage + Cloudinary CDN                     |
| **Image Upload**    | Cloudinary API (primary), Firebase Storage (backup)   |
| **Image Loading**   | SDWebImage with async/cache support                   |
| **External APIs**   | Currency Exchange API (xe.com / exchangerate-api.com) |
| **Package Manager** | Swift Package Manager (SPM)                           |
| **IDE**             | Xcode 16.3+                                           |

---

## 🏗️ Architecture

### MVVM Pattern (Model-View-ViewModel)

```
Model ←→ ViewModel ←→ View
  ↓        ↓           ↓
Codable   @Published   SwiftUI
Entity    @ObservedObject Binding
```

### Service Layer (Singleton Pattern)

- **AuthService** — Firebase Auth wrapper
- **FirestoreService** — Firestore CRUD operations
- **StorageService** — Firebase Storage (legacy, migration support)
- **CloudinaryService** — Cloudinary image upload & transformation
- **ReviewService** — Review/rating management
- **BuyRequestService** — Buy request (reverse posting) operations
- **ChatService** — Real-time messaging via Firestore
- **CurrencyService** — Live exchange rate API calls

All services follow the singleton pattern: `SomeService.shared`

---

## 📁 Project Structure

```
KUET_Trade/
├── KUET_TradeApp.swift              # App entry point + Firebase init + @UIApplicationDelegateAdaptor
├── ContentView.swift                # Root navigation (Verification-aware auth gate)
├── GoogleService-Info.plist         # Firebase configuration
│
├── Models/
│   ├── User.swift                   # KTUser model (Firestore Codable, includes verification fields)
│   ├── Item.swift                   # Item model + ItemCategory enum + SortOption enum
│   ├── Review.swift                 # Review model (star rating + comment)
│   ├── BuyRequest.swift             # BuyRequest model (reverse posting)
│   ├── Message.swift                # Message model (chat message)
│   ├── Conversation.swift           # Conversation model (chat thread)
│   └── ExchangeRateResponse.swift    # API response model for currency rates
│
├── ViewModels/
│   ├── AuthViewModel.swift          # Auth state + verification status management
│   ├── ItemViewModel.swift          # Browse/search/filter items, CRUD
│   ├── PostItemViewModel.swift      # Create/edit item, Cloudinary upload
│   ├── BuyRequestViewModel.swift    # Create/browse buy requests
│   ├── ReviewViewModel.swift        # Write/read reviews
│   ├── ChatViewModel.swift          # Real-time messaging state
│   └── CurrencyViewModel.swift      # Live exchange rate management
│
├── Views/
│   ├── MainTabView.swift            # 4-tab root navigation (Home, Post, My Ads, Profile)
│   │
│   ├── Auth/
│   │   ├── LoginView.swift          # Email/password login screen
│   │   ├── SignUpView.swift         # Registration + department selection
│   │   ├── ForgotPasswordView.swift # Password reset screen
│   │   ├── PendingVerificationView.swift   # "Waiting for admin approval" screen
│   │   └── RejectedAccountView.swift       # "Account rejected" + reason display
│   │
│   ├── Admin/
│   │   ├── AdminDashboardView.swift # Admin main dashboard
│   │   ├── AdminLoginView.swift     # Admin login/access screen
│   │   ├── AllUsersView.swift       # View all registered users
│   │   ├── PendingUsersView.swift   # Pending verification queue
│   │   └── UserVerificationDetailView.swift # Individual user review & approve/reject
│   │
│   ├── Home/
│   │   ├── HomeView.swift           # Main feed (browse items + buy requests)
│   │   ├── ItemCardView.swift       # Single item card (thumbnail, price, seller info)
│   │   └── ItemDetailView.swift     # Full item detail + seller reviews + contact options
│   │
│   ├── Post/
│   │   ├── PostItemView.swift       # Create new item listing (Cloudinary upload)
│   │   └── EditItemView.swift       # Edit existing listing
│   │
│   ├── BuyRequests/
│   │   ├── PostBuyRequestView.swift # Create "want-to-buy" post
│   │   ├── BuyRequestsListView.swift# Browse all buy requests
│   │   └── BuyRequestDetailView.swift# View single buy request details
│   │
│   ├── Reviews/
│   │   ├── WriteReviewView.swift    # Leave 1-5 star + comment review
│   │   └── ReviewsListView.swift    # Browse all reviews for a seller
│   │
│   ├── Chat/
│   │   ├── ChatView.swift           # Message thread with individual user
│   │   ├── ConversationsListView.swift# List all active conversations
│   │   └── MessageBubbleView.swift  # Individual message bubble UI
│   │
│   ├── Search/
│   │   └── SearchFilterView.swift   # Search bar + category/dept/price filters
│   │
│   ├── Profile/
│   │   ├── MyAdsView.swift          # User's own listings dashboard (edit/delete/sold)
│   │   └── ProfileView.swift        # User profile + average rating + logout
│   │
│   └── Components/
│       ├── ImagePicker.swift        # UIImagePickerController wrapper (camera/gallery)
│       ├── LaunchScreenView.swift   # Splash screen
│       ├── ShimmerView.swift        # Loading skeleton animation
│       ├── ContactSellerButton.swift# Call/WhatsApp/Message action buttons
│       ├── StarRatingView.swift     # Interactive 1-5 star selector
│       └── (Additional UI components)
│
├── Services/
│   ├── AuthService.swift            # Firebase Auth (singleton) — signup/signin/signout/password reset
│   ├── FirestoreService.swift       # Firestore CRUD (singleton) — items, users, reviews, buy requests
│   ├── StorageService.swift         # Firebase Storage (singleton, legacy for migration)
│   ├── CloudinaryService.swift      # Cloudinary API (singleton) — image upload/transform/delete
│   ├── ReviewService.swift          # Review operations — write/read/average rating
│   ├── BuyRequestService.swift      # Buy request CRUD operations
│   ├── ChatService.swift            # Real-time Firestore chat — conversations, messages, read state
│   └── CurrencyService.swift        # External API — fetch live exchange rates
│
├── Utilities/
│   ├── Constants.swift              # App config, API keys, collection names, 18 departments
│   ├── Extensions.swift             # String validation, View helpers, Date/Double formatting
│   ├── FirestoreRules.swift         # Firestore security rules (reference)
│   ├── NetworkMonitor.swift         # Network connectivity checks
│   └── Color+Extensions.swift       # Custom color palette
│
└── Assets.xcassets/                 # App icons, accent colors, images
```

---

## 🗄️ Firestore Database Schema (Updated v2.0)

### `users` Collection

```
users/{userId}
├── uid: String                    # Firebase Auth UID
├── name: String                   # Full name
├── email: String                  # Email address
├── phone: String                  # WhatsApp/Call number
├── department: String             # KUET department (CSE, EEE, etc.)
├── joinedDate: Timestamp          # Account creation date
├── profileImageURL: String?       # User avatar (optional)
├── verificationStatus: String     # "approved" | "pending" | "rejected"
├── rejectionReason: String?       # Why admin rejected (optional)
├── averageRating: Double          # Computed from reviews collection
└── totalReviews: Int              # Count of reviews received
```

### `items` Collection

```
items/{itemId}
├── title: String                  # Item name
├── description: String            # Full description
├── price: Double                  # Price in BDT
├── category: String               # "Books" | "Electronics" | "Accessories" | "Others"
├── department: String             # KUET department
├── imageURLs: [String]            # Cloudinary URLs (1-5 images)
├── sellerID: String               # → users/{userId}
├── sellerName: String             # Seller display name
├── sellerPhone: String            # Seller phone
├── sellerVerified: Bool           # Is seller verified?
├── isAvailable: Bool              # Currently available?
├── isSold: Bool                   # Marked as sold?
├── createdAt: Timestamp
├── updatedAt: Timestamp
└── reviewsCount: Int              # Number of reviews on this listing
```

### `reviews` Collection

Review model for ratings and feedback.

### `buyRequests` Collection

For reverse posting — "Looking for X item" with details and price range.

### `conversations` Collection

Real-time messaging between buyers and sellers.

### `messages` Collection (Subcollection)

Individual messages within conversations.

---

## 👥 Team Attribution (v2.0 Update)

| Member            | GitHub                                         | v2.0 Features                                                                          |
| ----------------- | ---------------------------------------------- | -------------------------------------------------------------------------------------- |
| **Farid Ahmed**   | [@Farid-43](https://github.com/Farid-43)       | Trust & governance: admin verification, moderation, admin side, profile trust, filters |
| **Sayeem**        | [@Sayeem33](https://github.com/Sayeem33)       | Buyer experience: buy requests, ratings/reviews, discovery UI, currency support        |
| **Torikul Islam** | [@Torikul-048](https://github.com/Torikul-048) | Seller & communication: posting/edit, cloud media upload, messaging, app polish        |

---
