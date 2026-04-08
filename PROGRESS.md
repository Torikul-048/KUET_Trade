# 📊 KUET Trade — Development Progress Tracker

> Last Updated: March 1, 2026

---

## 🗺️ Phase Overview

| # | Phase | Description | Status | Date |
|---|-------|-------------|--------|------|
| 1 | Project Setup & Foundation | Firebase init, Models, Services, Utilities | ✅ Done | Mar 1, 2026 |
| 2 | Authentication | Login, Signup, Forgot Password, AuthViewModel | ✅ Done | Mar 1, 2026 |
| 3 | Home Feed & Item Display | HomeView, ItemCard, ItemDetail, ItemViewModel, MainTabView | ✅ Done | Mar 1, 2026 |
| 4 | Post & Edit Items | PostItemView, EditItemView, ImagePicker, PostItemViewModel | ✅ Done | Mar 1, 2026 |
| 5 | Search & Filter | SearchFilterView, price range, filter tags, active filter badge | ✅ Done | Mar 1, 2026 |
| 6 | My Ads Dashboard & Profile | MyAdsView, ProfileView, Edit/Delete/Sold | ✅ Done | Mar 1, 2026 |
| 7 | Contact Seller | Call button, WhatsApp deep link, SMS, ContactSellerSheet | ✅ Done | Mar 1, 2026 |
| 8 | Polish & Final Touches | Launch screen, shimmer loading, network monitor, validation UX, security rules | ✅ Done | Mar 1, 2026 |

---

## ✅ Phase 1: Project Setup & Foundation (COMPLETED)

### What Was Done
This phase established the entire foundation of the app — Firebase integration, data models, backend services, and utility helpers.

### Files Created / Modified

| File | Action | Purpose |
|------|--------|---------|
| `KUET_TradeApp.swift` | ✏️ Modified | Added Firebase initialization via `AppDelegate` |
| `ContentView.swift` | ✏️ Modified | Added auth state gate (splash → login or home) |
| `Models/User.swift` | 🆕 Created | `KTUser` struct — Firestore Codable, with initials computed property |
| `Models/Item.swift` | 🆕 Created | `Item` struct, `ItemCategory` enum (4 categories), `SortOption` enum |
| `Services/AuthService.swift` | 🆕 Created | Singleton — signup, signin, signout, password reset, fetch user, auth listener |
| `Services/FirestoreService.swift` | 🆕 Created | Singleton — CRUD for items, fetch by category, fetch by seller, toggle availability |
| `Services/StorageService.swift` | 🆕 Created | Singleton — upload image, upload multiple, delete image, delete multiple |
| `Utilities/Constants.swift` | 🆕 Created | App name, Firestore collection names, storage paths, 18 KUET departments, validation limits, colors |
| `Utilities/Extensions.swift` | 🆕 Created | String validation (email, phone), View helpers (hideKeyboard, cardStyle), Date/Double formatting |
| `README.md` | 🆕 Created | Full project documentation |
| `PROGRESS.md` | 🆕 Created | This file — phase-by-phase tracking |

### Architecture Decisions
- **MVVM Pattern**: Models ↔ ViewModels ↔ Views with clear separation
- **Singleton Services**: `AuthService.shared`, `FirestoreService.shared`, `StorageService.shared`
- **Firestore Codable**: Models use `@DocumentID` and `Codable` for automatic serialization
- **KTUser naming**: Named `KTUser` (not `User`) to avoid conflict with SwiftUI's `User` type
- **ItemCategory enum**: 4 categories — Books, Electronics, Accessories, Others — each with icon and color
- **Bangladesh Taka (৳)**: Currency formatting uses Taka symbol throughout

### Key Models

**KTUser** — Represents a registered student
```
uid, name, email, phone, department, joinedDate, profileImageURL?
```

**Item** — Represents a marketplace listing
```
title, description, price, category, imageURLs[], sellerID, sellerName, 
sellerPhone, isAvailable, createdAt, updatedAt
```

**ItemCategory** — Enum with 4 cases
```
.books ("Books") → book.fill icon
.electronics ("Electronics") → laptopcomputer icon
.accessories ("Accessories") → headphones icon
.others ("Others") → shippingbox.fill icon
```

### What the App Shows Right Now
- On launch: **Splash screen** with KUET Trade logo + loading spinner
- After auth check: Shows "Login screen coming in Phase 2" (if not logged in)
- If somehow logged in: Shows "You are logged in!" with a Sign Out button

---

## ✅ Phase 2: Authentication (COMPLETED)

### What Was Built
Complete authentication flow with polished UI — Login, Sign Up, Forgot Password screens, and a shared AuthViewModel driving all auth state.

### Files Created

| File | Action | Purpose |
|------|--------|---------|
| `ViewModels/AuthViewModel.swift` | 🆕 Created | `@MainActor ObservableObject` — manages all auth state, form fields, validation, error mapping, loading states, and Firebase auth listener |
| `Views/Auth/LoginView.swift` | 🆕 Created | Login screen — email/password fields, Login button, links to Sign Up (NavigationStack push) & Forgot Password (sheet) |
| `Views/Auth/SignUpView.swift` | 🆕 Created | Registration screen — name, email, phone, department dropdown (18 KUET depts), password, confirm password with live match indicator |
| `Views/Auth/ForgotPasswordView.swift` | 🆕 Created | Password reset — email field, Send Reset Link button, success state with confirmation message |

### Files Modified

| File | Change |
|------|--------|
| `ContentView.swift` | Replaced placeholder with actual `LoginView(viewModel:)`, uses `@StateObject` AuthViewModel, shows user info on logged-in screen |

### Features Implemented
- [x] AuthViewModel with `@Published` properties for all form fields & UI state
- [x] Form validation (email format, password length ≥ 6, phone 10–14 digits, all fields required)
- [x] Error alerts with human-readable Firebase auth error mapping (wrong password, email in use, network error, too many requests, etc.)
- [x] Loading spinner on Login, Sign Up, and Reset Password buttons during async operations
- [x] Department picker dropdown with all 18 KUET departments from `AppConstants`
- [x] Confirm password field with live green ✓ / red ✗ match indicator
- [x] Password reset email via Firebase with success confirmation UI
- [x] Auto-navigate on successful login/signup (Firebase auth state listener triggers transition)
- [x] Keyboard dismiss on tap gesture across all auth screens
- [x] Smooth animated transitions between splash → login → home states
- [x] Sign Out button on logged-in screen showing user name, email, department, phone
- [x] Navigation: Login → Sign Up (push), Login → Forgot Password (sheet)
- [x] "Back to Login" link on Sign Up, Cancel button on Forgot Password

### Architecture Details
- **AuthViewModel** is `@MainActor` and uses `@StateObject` in ContentView for lifecycle management
- Auth state listener auto-fetches `KTUser` from Firestore on login, clears on logout
- All Firebase `AuthErrorCode` cases mapped to user-friendly strings
- Fields are cleared after successful login/signup to prevent stale data
- `resetEmailSent` flag toggles between form and success state in ForgotPasswordView

### What the App Shows Right Now
- On launch: **Splash screen** with logo + spinner (while checking auth state)
- If not logged in: **LoginView** with email/password, links to Sign Up & Forgot Password
- On Sign Up tap: **SignUpView** pushed onto NavigationStack with full registration form
- On Forgot Password tap: **ForgotPasswordView** as a sheet with email input → success confirmation
- On successful login/signup: **Logged-in screen** showing "Welcome, [Name]!" with user details and Sign Out button
- Sign Out returns to LoginView with smooth animation

---

## ✅ Phase 3: Home Feed & Item Display (COMPLETED)

### What Was Built
Full home feed experience — TabView navigation, item grid with search/filter/sort, item cards with AsyncImage, and a rich item detail page with image gallery and contact seller buttons.

### Files Created

| File | Action | Purpose |
|------|--------|---------|
| `ViewModels/ItemViewModel.swift` | 🆕 Created | `@MainActor ObservableObject` — loads all items from Firestore, client-side search (title/description/seller/category), category filter, 4 sort options, pull-to-refresh, loading/empty states |
| `Views/MainTabView.swift` | 🆕 Created | 4-tab layout: Home (functional), Post Ad (placeholder), My Ads (placeholder), Profile (placeholder with Sign Out) |
| `Views/Home/HomeView.swift` | 🆕 Created | Main feed — search bar, horizontal category chips (All + 4 categories), sort dropdown menu, item count, 2-column LazyVGrid, loading spinner, empty state with "Clear Filters" button, pull-to-refresh |
| `Views/Home/ItemCardView.swift` | 🆕 Created | Compact card — AsyncImage with loading/error states, category badge overlay (`.ultraThinMaterial`), title (2-line), price in ৳, time ago |
| `Views/Home/ItemDetailView.swift` | 🆕 Created | Full detail — swipeable TabView image gallery with page counter, title, price, category chip, posted time, description, seller info with avatar initials, Call Seller button, WhatsApp deep link button |

### Files Modified

| File | Change |
|------|--------|
| `ContentView.swift` | Replaced placeholder logged-in screen with `MainTabView(authViewModel:)` |

### Features Implemented
- [x] **MainTabView** with 4 tabs — Home, Post Ad, My Ads, Profile
- [x] **ItemViewModel** with `@Published` reactive filters via `didSet` triggers
- [x] **Search** — client-side search across title, description, seller name, and category
- [x] **Category filter** — horizontal scrollable chips: All, Books, Electronics, Accessories, Others
- [x] **Sort options** — Newest First, Oldest First, Price Low→High, Price High→Low
- [x] **Item count** — live "X items" counter updates with filters
- [x] **Pull-to-refresh** — `.refreshable` async reload from Firestore
- [x] **Loading state** — centered ProgressView with "Loading items..." text
- [x] **Empty state** — different messages for "no items yet" vs "no results found" with Clear Filters button
- [x] **ItemCardView** — AsyncImage with 3 phases (loading/success/error), category badge overlay, price in ৳, relative time
- [x] **ItemDetailView** — swipeable image gallery (TabView `.page` style), image counter "1 / 3"
- [x] **Seller info section** — avatar with computed initials, name, phone number
- [x] **Call Seller** — `tel://` URL scheme to open phone dialer
- [x] **WhatsApp deep link** — converts BD local numbers (01X) to +880X format, pre-fills message with item title
- [x] **No-image placeholders** — graceful fallback for items without photos (card + detail)
- [x] **Sign Out** — available in Profile placeholder tab (red button)
- [x] **Keyboard dismiss** on tap in HomeView search

### Architecture Details
- **ItemViewModel** loaded via `@StateObject` in `MainTabView`, passed as `@ObservedObject` to `HomeView`
- Filters use `didSet` on `@Published` properties → instant `applyFilters()` call on any change
- All filtering/sorting is client-side after initial Firestore fetch (efficient for campus-scale data)
- `hasActiveFilters` computed property drives empty state messaging
- `CategoryChip` is a reusable component extracted within `HomeView.swift`
- `PlaceholderTabView` is a reusable stub for future phase tabs
- WhatsApp URL uses `https://wa.me/` format (works without app installed, falls back to web)

### What the App Shows Right Now
- On login: **MainTabView** with 4 tabs (Home, Post Ad, My Ads, Profile)
- **Home tab**: Search bar → category chips → sort menu → 2-column item grid (or loading/empty state)
- Tapping an item card: **ItemDetailView** with image gallery, full details, and Call/WhatsApp buttons
- **Post Ad / My Ads tabs**: Placeholder screens with "Coming in Phase X"
- **Profile tab**: Placeholder with red Sign Out button

---

## ✅ Phase 4: Post & Edit Items (COMPLETED)

### What Was Built
Full item posting and editing flow — image picker (camera + photo library), form with validation and character counters, Firebase Storage image upload, Firestore document creation/update, and a success state after posting.

### Files Created

| File | Action | Purpose |
|------|--------|---------|
| `ViewModels/PostItemViewModel.swift` | 🆕 Created | `@MainActor ObservableObject` — form fields, image management (add/remove new + existing), validation (title/desc length, price range, min 1 photo), post new item (upload images → create Firestore doc), update existing item (upload new + delete removed images → update doc) |
| `Views/Components/ImagePicker.swift` | 🆕 Created | `UIViewControllerRepresentable` wrapper for `UIImagePickerController` — supports `.camera` and `.photoLibrary` sources, editing enabled, coordinator pattern |
| `Views/Post/PostItemView.swift` | 🆕 Created | Create new listing — horizontal image scroll with add/remove, title with char counter, TextEditor description with placeholder + char counter, price field (number pad), category chips, Post button with loading spinner, success state with "Post Another" |
| `Views/Post/EditItemView.swift` | 🆕 Created | Edit existing listing — shows existing images (AsyncImage) with red remove buttons, add new photos section, all fields pre-populated via `loadItem()`, Update button, auto-dismiss on success, Cancel toolbar button |

### Files Modified

| File | Change |
|------|--------|
| `Views/MainTabView.swift` | Replaced Post Ad placeholder with actual `PostItemView(itemViewModel:)` |

### Features Implemented
- [x] **ImagePicker** — UIKit bridge supporting camera (physical device) + photo library with editing
- [x] **Image source picker** — `.confirmationDialog` lets user choose Camera or Photo Library
- [x] **Horizontal image scroll** — add up to 3 photos, each with ✗ remove button overlay
- [x] **Image counter** — live "X/3" counter for photos
- [x] **Title field** — with live character counter (0/80), turns red when exceeded
- [x] **Description field** — TextEditor with floating placeholder text, live char counter (0/500)
- [x] **Price field** — number pad keyboard, validates > 0 and ≤ ৳999,999
- [x] **Category picker** — horizontal scrollable chips matching HomeView style
- [x] **Form validation** — title required, description required, price > 0, at least 1 photo for new posts
- [x] **Post flow** — uploads images to Firebase Storage → creates Firestore document → clears form → shows success
- [x] **Success state** — green checkmark + "Posted Successfully!" + "Post Another Item" button
- [x] **Auto-refresh** — home feed refreshes after posting via shared `itemViewModel.refresh()`
- [x] **Edit flow** — `loadItem()` pre-fills all fields, shows existing images as AsyncImage with remove
- [x] **Edit images** — remove existing images (deleted from Storage), add new images alongside existing
- [x] **Update flow** — uploads new images + deletes removed → updates Firestore doc → auto-dismiss
- [x] **Edit callback** — `onUpdate` closure lets parent views refresh after edit
- [x] **Camera fallback** — camera option only shown when `UIImagePickerController.isSourceTypeAvailable(.camera)`
- [x] **Loading spinner** — on Post and Update buttons during async operations
- [x] **Error alerts** — validation errors + Firebase upload/write errors shown as alerts
- [x] **Keyboard dismiss** — tap gesture on both Post and Edit views

### Architecture Details
- **PostItemViewModel** is reused by both `PostItemView` (create mode) and `EditItemView` (edit mode)
- `isEditMode` computed property checks if `editingItem != nil` to toggle behavior
- `pickedImage` uses `didSet` to auto-append to `selectedImages` array — seamless from ImagePicker
- `totalImageCount` = `selectedImages.count + existingImageURLs.count` — enforces max 3 across both
- `canAddMore` checks total count, `canAddMoreImages` checks only new images
- Image upload path: `item_images/{userUID}/{UUID}/image_{index}_{UUID}.jpg`
- Edit mode tracks removed existing URLs and deletes them from Storage on update
- `didEditSuccessfully` triggers `.onChange` → calls `onUpdate?()` → dismisses view

### What the App Shows Right Now
- **Post tab**: Full form with image picker → title → description → price → category → Post button
- After posting: Success screen with "Post Another Item" button, home feed auto-refreshes
- **Edit** (available from future My Ads phase): Pre-populated form with existing images, Update button, auto-dismiss
- Camera option appears only on physical devices
- **My Ads / Profile tabs**: Still placeholder (Phase 6)

---

## ✅ Phase 5: Search & Filter (COMPLETED)

### What Was Built
Dedicated Search & Filter experience — a full-screen filter sheet with search, category selection, price range (with quick presets), sort options, live result count, and dismissible filter tags on the home feed.

### Files Created

| File | Action | Purpose |
|------|--------|---------|
| `Views/Search/SearchFilterView.swift` | 🆕 Created | Full filter sheet — search bar, category list with checkmarks & colored icons, price range (min/max fields + 4 quick presets), sort options with checkmarks, live result count + active filter count, "Clear All Filters" button |

### Files Modified

| File | Change |
|------|--------|
| `ViewModels/ItemViewModel.swift` | Added `minPrice` / `maxPrice` `@Published` properties with `didSet`, price range filtering in `applyFilters()`, `activeFilterCount` computed property, `priceRangeDescription` for display, updated `clearFilters()` and `hasActiveFilters` |
| `Views/Home/HomeView.swift` | Added filter button (inline in search bar + toolbar icon), `@State showFilterSheet`, active filter tags row (dismissible `FilterTag` chips), `.sheet` presenting `SearchFilterView`, `FilterTag` reusable component |

### Features Implemented
- [x] **SearchFilterView** — full List-based filter sheet opened as `.sheet`
- [x] **Search section** — text field with clear button, synced with `itemViewModel.searchText`
- [x] **Category section** — "All Categories" + 4 categories with colored icons and checkmark selection
- [x] **Price range section** — min/max text fields with number pad keyboard
- [x] **Quick price presets** — "Under ৳200", "৳200–৳500", "৳500–৳1000", "৳1000+" one-tap chips
- [x] **Active price range display** — shows "৳200 – ৳500" or "৳1000+" with Clear button
- [x] **Sort section** — 4 sort options with checkmark on active selection
- [x] **Results preview** — live "X items found" + "Y filters active" counter
- [x] **Clear All Filters** — red destructive button, only shown when filters are active
- [x] **Filter button in search bar** — slider icon with red badge showing active filter count
- [x] **Toolbar filter icon** — filled when filters are active, outline when not
- [x] **Active filter tags** — horizontal scrollable row of dismissible chips below search bar
- [x] **Individual tag dismissal** — tap ✗ on any tag to remove just that filter
- [x] **"Clear All" tag** — red chip at end of tag row to reset everything
- [x] **Price range filtering** — items filtered by min and/or max price in `applyFilters()`
- [x] **Done button** — dismisses filter sheet, results update live as you change filters

### Architecture Details
- **Price range** uses String-based `minPrice`/`maxPrice` with `didSet` triggers (same pattern as other filters)
- `priceRangeDescription` computed property returns human-readable range or `nil`
- `activeFilterCount` counts each active dimension (search, category, sort, price) separately
- `FilterTag` is a reusable dismissible chip component in `HomeView.swift`
- `PricePresetChip` is a reusable component in `SearchFilterView.swift`
- All filters apply in real-time — no "Apply" button needed, changes reflect immediately
- Filter sheet uses `@ObservedObject` on same `itemViewModel` — changes sync bidirectionally with HomeView

### What the App Shows Right Now
- **Home tab**: Search bar with inline filter button (badge shows count) + toolbar filter icon
- Active filters show as **dismissible tags** below search bar (category, price range, sort, search text + "Clear All")
- Tapping filter button → **SearchFilterView sheet** with all filter options
- Changing any filter instantly updates the item grid behind the sheet
- Tapping "Done" → sheet dismisses, home feed already reflects filters
- **Price range filtering** works alongside category and search filters

---

## ✅ Phase 6: My Ads Dashboard & Profile (COMPLETED)

### What Was Built
Complete My Ads dashboard with listing management (edit, delete, mark as sold/relist) and a polished Profile screen with user info display and sign out confirmation.

### Files Created

| File | Action | Purpose |
|------|--------|---------|
| `Views/Profile/MyAdsView.swift` | 🆕 Created | User's own listings — summary stats (Active/Sold/Total), sectioned list (Active vs Sold), swipe-to-edit (right), swipe-to-delete (right), swipe-to-mark-sold (left), swipe-to-relist (left), delete confirmation alert, edit via sheet, pull-to-refresh, loading/empty states, auto-refreshes home feed |
| `Views/Profile/ProfileView.swift` | 🆕 Created | User profile — avatar with initials, name, department badge, contact info (email/phone), account info (department/member since), app info section, Sign Out with confirmation dialog |

### Files Modified

| File | Change |
|------|--------|
| `Views/MainTabView.swift` | Replaced My Ads placeholder with `MyAdsView(authViewModel:itemViewModel:)`, replaced Profile placeholder with `ProfileView(authViewModel:)` |

### Features Implemented

#### MyAdsView
- [x] **Summary stats** — Active / Sold / Total count badges at top with colored numbers
- [x] **Sectioned list** — "Active (X)" and "Sold (X)" sections, each with item rows
- [x] **MyAdRow** — thumbnail (AsyncImage), title, category icon+label, price in ৳, Active/Sold badge, time ago
- [x] **Swipe right → Delete** — red destructive swipe action with confirmation alert
- [x] **Swipe right → Edit** — blue swipe action opens `EditItemView` as sheet
- [x] **Swipe left → Mark Sold** — orange swipe action toggles `isAvailable` to false (active items)
- [x] **Swipe left → Relist** — green swipe action toggles `isAvailable` back to true (sold items)
- [x] **Delete confirmation** — alert with item title, Cancel + Delete (destructive) buttons
- [x] **Delete flow** — deletes images from Storage → deletes Firestore doc → refreshes list + home feed
- [x] **Edit via sheet** — opens `EditItemView` in `NavigationStack` sheet, auto-refreshes on update
- [x] **Pull-to-refresh** — `.refreshable` async reload of user items
- [x] **Loading state** — spinner + "Loading your ads..."
- [x] **Empty state** — icon + "No Ads Yet" + message directing to Post tab
- [x] **Ad count** — toolbar shows "X ads" count
- [x] **Auto-refresh home** — after edit/delete/sold toggle, home feed `itemViewModel.refresh()` is called

#### ProfileView
- [x] **Avatar** — circle with computed initials from user name, accent color
- [x] **Name display** — large bold title
- [x] **Department badge** — colored chip below name
- [x] **Contact section** — email (blue icon), phone (green icon) with label + value layout
- [x] **Account section** — department (purple icon), member since date (orange icon)
- [x] **App info section** — app name + university
- [x] **Sign Out** — red destructive button at bottom
- [x] **Sign Out confirmation** — `.confirmationDialog` with "Are you sure?" message
- [x] **ProfileInfoRow** — reusable component with colored icon, label, and value

### Reusable Components Created
- **`MyAdRow`** — item row with thumbnail, details, status badge, time ago
- **`StatBadge`** — count + label with color (used for Active/Sold/Total summary)
- **`ProfileInfoRow`** — icon + label + value row (used for contact/account info)

### Architecture Details
- **MyAdsView** uses `@State` for local items list (not shared `itemViewModel`) since it fetches seller-specific items via `fetchUserItems(userID:)`
- Edit sheet uses `.sheet(item: $editingItem)` with `Item` as `Identifiable` — auto-passes the item
- Delete flow: `try? await StorageService.shared.deleteImages()` (soft fail on images) → `try await FirestoreService.shared.deleteItem()` (hard fail on doc)
- Toggle sold uses `FirestoreService.shared.toggleAvailability()` which updates both `isAvailable` and `updatedAt`
- Both MyAdsView and ProfileView receive `authViewModel` as `@ObservedObject` from `MainTabView`
- MyAdsView also receives `itemViewModel` to trigger home feed refresh after mutations
- `PlaceholderTabView` still exists in `MainTabView.swift` but is no longer used (kept for potential future use)

### What the App Shows Right Now
- **All 4 tabs are now fully functional** — Home, Post, My Ads, Profile
- **My Ads tab**: Summary stats → Active items section → Sold items section, with full swipe actions
- **Profile tab**: User avatar + name + department → contact info → account info → app info → Sign Out
- Swipe right on active item: Edit (blue) + Delete (red)
- Swipe left on active item: Mark Sold (orange)
- Swipe left on sold item: Relist (green)
- Swipe right on sold item: Delete (red)
- Sign Out shows confirmation dialog before proceeding

---

## ✅ Phase 7: Contact Seller (COMPLETED)

### What Was Built
Complete reusable contact seller system — `ContactMethod` enum (Call/WhatsApp/SMS), `ContactSellerButton` with full & compact styles, `ContactSellerButtons` (full-width stack), `ContactSellerCompactRow` (icon row), `ContactSellerSheet` (full contact experience with seller info, item preview, safety notice), and refactored `ItemDetailView` to use all components with toolbar contact button.

### Files Created

| File | Action | Purpose |
|------|--------|---------|
| `Views/Components/ContactSellerButton.swift` | 🆕 Created | `ContactMethod` enum (call/whatsApp/sms with icon, color, label), `ContactSellerButton` (single button — full/compact styles, `canOpenURL` checks, alert fallback), `ContactSellerButtons` (full-width stack: Call + WhatsApp/SMS side-by-side), `ContactSellerCompactRow` (3 compact icon buttons in a row), `ContactSellerSheet` (full contact sheet — seller avatar/name/phone, item preview card, 3 contact buttons, safety notice) |

### Files Modified

| File | Change |
|------|--------|
| `Views/Home/ItemDetailView.swift` | Removed inline `callSeller()` and `openWhatsApp()` methods, replaced with `ContactSellerCompactRow` + `ContactSellerButtons` components, added `@State showContactSheet`, toolbar contact button (phone.circle.fill), `.sheet` presenting `ContactSellerSheet` with `.presentationDetents([.medium, .large])`, quick contact button next to seller info, safety tip text |

### Features Implemented
- [x] **ContactMethod enum** — `.call`, `.whatsApp`, `.sms` with icon, color, and label properties
- [x] **ContactSellerButton** — single reusable button supporting full & compact styles
- [x] **Full style** — colored background, white text, full-width, rounded corners
- [x] **Compact style** — colored tinted background, icon + label stacked vertically
- [x] **Call action** — `tel://` URL scheme with `canOpenURL` check + alert fallback
- [x] **WhatsApp action** — `https://wa.me/` deep link, BD local→international conversion (+88), pre-filled message with item title
- [x] **SMS action** — `sms:` URL scheme with pre-filled body message, `canOpenURL` check + alert fallback
- [x] **Phone cleaning** — strips spaces and dashes from phone numbers
- [x] **International format** — converts `01X...` to `+8801X...` for WhatsApp
- [x] **Unavailable alerts** — per-method alert messages when device can't open URL
- [x] **ContactSellerButtons** — Call full-width on top, WhatsApp + SMS side-by-side below
- [x] **ContactSellerCompactRow** — 3 compact buttons in a horizontal row (for inline use)
- [x] **ContactSellerSheet** — full contact experience as half/full sheet
- [x] **Sheet seller header** — avatar circle with initials, name, phone number
- [x] **Sheet item preview** — thumbnail + "Contacting about:" + title + price in card
- [x] **Sheet safety notice** — shield icon + "Meet in a safe, public place on campus"
- [x] **Toolbar contact button** — phone.circle.fill icon in navigation bar trailing
- [x] **Inline quick contact** — ellipsis.message.fill button next to seller info
- [x] **Sheet presentation detents** — `.medium` and `.large` for flexible height
- [x] **ItemDetailView refactored** — old inline methods removed, uses reusable components throughout

### Reusable Components Created
- **`ContactMethod`** — enum with icon, color, label (used everywhere)
- **`ContactSellerButton`** — single button with full/compact style variants
- **`ContactSellerButtons`** — full-width button stack (Call + WhatsApp/SMS)
- **`ContactSellerCompactRow`** — compact 3-button icon row
- **`ContactSellerSheet`** — full contact sheet with seller info + item preview

### Architecture Details
- **ContactSellerButton** uses `ButtonStyle` enum (`.full` / `.compact`) — not SwiftUI's `ButtonStyle` protocol
- Phone number cleaning strips spaces and dashes before URL creation
- `internationalPhone()` handles BD local format (0XX) → +88XX conversion
- `canOpenURL` check prevents crashes on simulator (no phone/SMS capability)
- Alert fallback shows method-specific error message when URL can't be opened
- WhatsApp uses `https://wa.me/` format (universal link — works with/without app installed)
- SMS uses `sms:` scheme with `&body=` parameter for pre-filled message
- `ContactSellerSheet` uses `.presentationDetents([.medium, .large])` for flexible sizing
- All contact components accept `phone` and `itemTitle` as parameters — fully decoupled from `Item` model
- `ContactSellerSheet` accepts full `Item` for thumbnail + price display

### What the App Shows Right Now
- **ItemDetailView**: Seller info with quick contact button → compact 3-button row (Call/WhatsApp/SMS) → full-width contact buttons → safety tip
- **Toolbar**: Phone icon opens `ContactSellerSheet` as half-sheet
- **ContactSellerSheet**: Seller avatar + name + phone → item preview card → Call/WhatsApp/SMS buttons → safety notice → Close button
- **3 contact methods**: Call (accent), WhatsApp (green), SMS (blue) — each with `canOpenURL` checks
- **All contact logic** is now in reusable components — no inline methods in views

---

## ✅ Phase 8: Polish & Final Touches (COMPLETED)

### What Was Built
Full polish pass across the entire app — animated launch screen, shimmer skeleton loading, network connectivity monitoring with offline banner, inline form validation with haptic feedback, SOLD overlay badges, share app sheet, app version display, and Firestore/Storage security rules reference.

### Files Created

| File | Action | Purpose |
|------|--------|---------|
| `Views/Components/LaunchScreenView.swift` | 🆕 Created | Animated splash screen — pulsing app icon, gradient background, animated tagline, version number, fade-in sequence with staggered delays |
| `Views/Components/ShimmerView.swift` | 🆕 Created | `ShimmerModifier` (animating gradient overlay), `ShimmerView` (shape with shimmer effect), `SkeletonCardView` (placeholder item card), `SkeletonGridView` (2-column grid of 6 skeleton cards) |
| `Utilities/NetworkMonitor.swift` | 🆕 Created | `NetworkMonitor` — `NWPathMonitor`-based connectivity observer, `@Published isConnected`, `connectionType` (WiFi/Cellular/etc), `OfflineBannerView` (red/yellow animated banner) |
| `Utilities/FirestoreRules.swift` | 🆕 Created | Reference-only file documenting recommended Firestore security rules (users: read all, write own; items: read all, create/update/delete own) and Storage rules (image size limits, content type validation, owner-only writes) |

### Files Modified

| File | Change |
|------|--------|
| `ContentView.swift` | Replaced plain splash with animated `LaunchScreenView`, added smooth fade transition to auth/main views |
| `Views/MainTabView.swift` | Added `@StateObject NetworkMonitor`, `OfflineBannerView` overlay when offline, haptic feedback on tab selection via `sensoryFeedback` |
| `Views/Home/HomeView.swift` | Replaced `ProgressView` loading state with `SkeletonGridView` shimmer skeleton animation |
| `Views/Home/ItemCardView.swift` | Added "SOLD" overlay badge with red diagonal banner when `!item.isAvailable`, reduced opacity for sold items |
| `Views/Home/ItemDetailView.swift` | Added "SOLD" banner overlay on images, "This item has been sold" notice section, disabled contact buttons for sold items, hide contact for own items (seller can't contact themselves), `@EnvironmentObject`-free check via `AuthViewModel.shared` |
| `Views/Profile/ProfileView.swift` | Added app version (CFBundleShortVersionString + build), app info section (name/version/university), Share App button with `UIActivityViewController` wrapper (`ShareSheet`), haptic feedback on sign out (`UINotificationFeedbackGenerator`), footer with "Made with ❤️ for KUET" |
| `Views/Post/PostItemView.swift` | Added `hasAttemptedSubmit` state for deferred validation, inline error labels (red ⚠️ icon + message) for title/description/price/images, red border highlights on invalid fields, haptic feedback on post button (`UIImpactFeedbackGenerator`), success haptic (`UINotificationFeedbackGenerator`), photo section turns red when invalid |

### Features Implemented

#### Launch Screen
- [x] **Animated splash** — pulsing cart icon with scale + opacity animation
- [x] **Gradient background** — blue-to-purple diagonal gradient
- [x] **Staggered fade-in** — icon → app name → tagline → version appear sequentially
- [x] **Version display** — shows app version from bundle info
- [x] **Smooth transition** — animated opacity switch from splash to auth/main content

#### Shimmer Skeleton Loading
- [x] **ShimmerModifier** — reusable `.shimmering()` view modifier with animating linear gradient
- [x] **SkeletonCardView** — placeholder card matching `ItemCardView` layout (image area + text lines + price)
- [x] **SkeletonGridView** — 2-column grid of 6 skeleton cards with staggered animation delays
- [x] **Replaced ProgressView** — HomeView loading state now shows beautiful shimmer skeletons

#### Network Connectivity
- [x] **NetworkMonitor** — `NWPathMonitor` with `@Published isConnected` and `connectionType`
- [x] **OfflineBannerView** — animated red banner with Wi-Fi slash icon + "No Internet Connection"
- [x] **MainTabView integration** — offline banner overlays content when disconnected
- [x] **Auto-dismiss** — banner disappears automatically when connection is restored

#### SOLD State Polish
- [x] **ItemCardView SOLD badge** — red "SOLD" overlay with semi-transparent background on sold items
- [x] **ItemDetailView SOLD banner** — "SOLD" text overlay on image gallery for sold items
- [x] **Sold notice section** — info banner "This item has been sold" below images
- [x] **Disabled contact** — contact buttons hidden/disabled for sold items
- [x] **Own item detection** — contact buttons hidden when viewing your own listing

#### Form Validation UX
- [x] **Deferred validation** — errors only show after first submit attempt (`hasAttemptedSubmit`)
- [x] **Inline error labels** — red ⚠️ icon + message below each invalid field
- [x] **Red border highlights** — invalid fields get red stroke overlay
- [x] **Photo section indicator** — add photo button turns red when no photos after submit
- [x] **Haptic feedback** — medium impact on post button tap, success notification on successful post
- [x] **Reset on success** — `hasAttemptedSubmit` resets when posting another item

#### Profile Enhancements
- [x] **App version display** — `CFBundleShortVersionString` + build number in profile
- [x] **App info section** — App Name, Version, University rows
- [x] **Share App** — `UIActivityViewController` wrapper with pre-filled share text
- [x] **Sign out haptic** — warning notification feedback on sign out
- [x] **Footer** — "Made with ❤️ for KUET" + copyright notice

#### Security Rules Reference
- [x] **Firestore rules** — users (read: auth, write: own), items (read: auth, create/update/delete: own seller)
- [x] **Storage rules** — item images (5MB max, images only, owner write), profile images (2MB max, owner write)
- [x] **Documentation** — full rule sets documented as Swift doc comments for easy copy to Firebase Console

### Reusable Components Created
- **`LaunchScreenView`** — animated splash screen (standalone, used in ContentView)
- **`ShimmerModifier`** — `.shimmering()` view modifier for any view
- **`ShimmerView`** — configurable shimmer shape (width/height/cornerRadius)
- **`SkeletonCardView`** — placeholder card skeleton
- **`SkeletonGridView`** — full grid of skeleton cards
- **`NetworkMonitor`** — singleton-style connectivity observer
- **`OfflineBannerView`** — offline status banner
- **`ShareSheet`** — `UIActivityViewController` SwiftUI wrapper

### Architecture Details
- **NetworkMonitor** uses `NWPathMonitor` on a dedicated `DispatchQueue("NetworkMonitor")`
- **ShimmerModifier** uses `@State animating` with `Animation.linear(duration: 1.5).repeatForever` and `LinearGradient` mask
- **SkeletonGridView** uses staggered `animation(.easeInOut.delay(Double(index) * 0.05))` for wave effect
- **LaunchScreenView** uses `@State` booleans with `DispatchQueue.main.asyncAfter` for sequenced animations
- **Inline validation** only triggers after `hasAttemptedSubmit = true` — prevents premature error display
- **Own item check** uses `AuthViewModel.shared.currentUser?.uid` to compare with `item.sellerID`
- **ShareSheet** wraps `UIActivityViewController` via `UIViewControllerRepresentable`
- **OfflineBannerView** positioned as `.overlay(alignment: .top)` in MainTabView with `animation(.spring)`

### What the App Shows Right Now
- **Launch**: Beautiful animated splash screen with pulsing icon, gradient, staggered text
- **Home feed loading**: 6 shimmer skeleton cards in 2-column grid instead of plain spinner
- **Offline**: Red banner slides in from top when internet disconnects, auto-hides on reconnect
- **Sold items**: "SOLD" badge on cards, "SOLD" banner on detail images, disabled contact buttons
- **Own items**: Contact buttons hidden when viewing your own listing
- **Post form**: Inline red errors + red borders appear only after first submit attempt
- **Post success**: Haptic success feedback + green checkmark
- **Profile**: App version, Share App button, haptic on sign out, footer
- **🎉 ALL 8 PHASES COMPLETE — App is fully functional and polished!**

---

## 📝 Notes & Reminders

### ⚠️ Important: SPM Packages Required
Before Phase 2 can compile, you MUST add Firebase SPM packages in Xcode:

1. Open `KUET_Trade.xcodeproj` in Xcode
2. Go to **File → Add Package Dependencies**
3. Enter URL: `https://github.com/firebase/firebase-ios-sdk`
4. Select these products:
   - ☑️ `FirebaseAuth`
   - ☑️ `FirebaseFirestore`
   - ☑️ `FirebaseStorage`
5. Click **Add Package**

### Firestore Indexes Needed (Phase 3+)
When you start querying with multiple `whereField` + `orderBy`, Firebase may ask you to create composite indexes. Click the link in the Xcode console error to auto-create them.

### Camera Testing
Camera (`UIImagePickerController` with `.camera` source) only works on **physical devices**, not simulators. Photo library works on both.
