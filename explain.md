# KUET Trade - শুরুর জন্য প্রজেক্ট ব্যাখ্যা

এই ডকুমেন্টটি প্রজেক্টটা দ্রুত বোঝার জন্য একটি স্টার্টার গাইড।

এখনকার লক্ষ্য:

- পুরো অ্যাপের একটি ছোট, সহজ ভাষার ব্যাখ্যা দেওয়া
- পরে ফাইল-ভিত্তিক ফুল ডিটেইলস যোগ করার জন্য একটি রোডম্যাপ তৈরি করা

---

## 1) ছোট ব্যাখ্যা (First Look)

KUET Trade হলো KUET শিক্ষার্থীদের জন্য একটি iOS মার্কেটপ্লেস অ্যাপ।

মূল আইডিয়া:

- স্টুডেন্টরা অ্যাকাউন্ট খুলে লগইন করতে পারে
- তারা বই, ইলেকট্রনিকস ইত্যাদি আইটেম ছবি সহ পোস্ট করতে পারে
- অন্য স্টুডেন্টরা আইটেম ব্রাউজ, সার্চ, ফিল্টার করে সেলারকে কনট্যাক্ট করতে পারে
- সেলাররা নিজের বিজ্ঞাপন এডিট, sold মার্ক, অথবা ডিলিট করতে পারে

ব্যবহৃত টেকনোলজি:

- **SwiftUI**: UI তৈরির জন্য
- **MVVM-style structure**: Views + ViewModels + Services + Models
- **Firebase**:
  - Auth (login/signup)
  - Firestore (users + items data)
  - Storage (item images)

---

## 2) অ্যাপের হাই-লেভেল ফ্লো

1. অ্যাপ চালু হলে Firebase configure হয়
2. ContentView auth state চেক করে
3. auth চেক চললে launch animation দেখায়
4. user logged in থাকলে main tab app দেখায়
5. logged in না থাকলে login screen দেখায়
6. logged-in user যা করতে পারে:
   - আইটেম ব্রাউজ/সার্চ/ফিল্টার
   - আইটেম ডিটেইলস খুলে সেলারকে কনট্যাক্ট
   - নতুন ad পোস্ট
   - My Ads থেকে নিজের ad manage
   - profile দেখা এবং sign out

---

## 3) আর্কিটেকচার (সহজভাবে)

- **Models**: ডেটার গঠন (Item, KTUser)
- **Services**: Firebase এর সাথে যোগাযোগ (AuthService, FirestoreService, StorageService)
- **ViewModels**: business logic এবং screen state (AuthViewModel, ItemViewModel, PostItemViewModel)
- **Views**: UI screen/component
- **Utilities**: constants, extensions, network status, rule references

সহজভাবে ভাবলে:

- Views ডেটা দেখায়
- ViewModels ডেটা/স্টেট ম্যানেজ করে
- Services Firebase থেকে ডেটা আনে/সেভ করে
- Models ডেটার ফরম্যাট নির্ধারণ করে

---

## 4) ফাইল ম্যাপ (প্রতিটি ফাইলের দ্রুত কাজ)

### Root

- KUET_TradeApp.swift: অ্যাপের entry point, Firebase configure করে
- ContentView.swift: প্রথমে কোন screen দেখাবে তা ঠিক করে (launch/login/main tabs)
- GoogleService-Info.plist: Firebase project configuration

### Models

- Models/Item.swift: Item model + category/sort enums
- Models/User.swift: User model (KTUser)

### Services

- Services/AuthService.swift: signup/login/logout/reset password + auth listener
- Services/FirestoreService.swift: Firestore এ item CRUD
- Services/StorageService.swift: Firebase Storage এ image upload/delete

### ViewModels

- ViewModels/AuthViewModel.swift: auth state, form state, validation, user loading
- ViewModels/ItemViewModel.swift: item loading, search/filter/sort logic
- ViewModels/PostItemViewModel.swift: post/edit form logic, validation, image handling

### Utilities

- Utilities/Constants.swift: app constants (department, limit, path)
- Utilities/Extensions.swift: helper extensions (email/phone validation, trim, etc.)
- Utilities/NetworkMonitor.swift: internet monitor + offline banner
- Utilities/FirestoreRules.swift: Firebase security rules reference (ডকুমেন্টেশন, রান হয় না)

### Views (Main)

- Views/MainTabView.swift: main tab navigation (Home, Post, My Ads, Profile)

### Views/Auth

- Views/Auth/LoginView.swift: login screen
- Views/Auth/SignUpView.swift: sign-up screen
- Views/Auth/ForgotPasswordView.swift: password reset screen

### Views/Home

- Views/Home/HomeView.swift: browse/search/filter + item grid
- Views/Home/ItemCardView.swift: প্রতিটি item এর ছোট কার্ড
- Views/Home/ItemDetailView.swift: full item details + contact options

### Views/Post

- Views/Post/PostItemView.swift: নতুন listing তৈরি
- Views/Post/EditItemView.swift: existing listing edit

### Views/Profile

- Views/Profile/MyAdsView.swift: নিজের listing manage (active/sold/edit/delete)
- Views/Profile/ProfileView.swift: user profile, app share, sign out

### Views/Search

- Views/Search/SearchFilterView.swift: advanced search/filter sheet

### Views/Components

- Views/Components/ContactSellerButton.swift: call/WhatsApp/SMS actions
- Views/Components/ImagePicker.swift: camera/gallery picker bridge
- Views/Components/LaunchScreenView.swift: animated launch screen
- Views/Components/ShimmerView.swift: skeleton loading placeholders

---

## 5) এই প্রজেক্টে এখন যা কাজ করছে (Feature Snapshot)

- Authentication flow (signup/login/reset/logout)
- Firestore এ user profile data
- ছবি সহ item posting
- item browsing এবং detail page
- search + category + price + sort filters
- seller contact actions
- My Ads management (edit, sold toggle, delete)
- network state অনুযায়ী offline banner

---

## 6) শেখার সাজেস্টেড অর্ডার (Mac ছাড়াই)

নিচের ক্রমে কোড পড়লে পুরো প্রজেক্ট সহজে বোঝা যাবে:

1. KUET_TradeApp.swift
2. ContentView.swift
3. Views/MainTabView.swift
4. Models/\*
5. Services/\*
6. ViewModels/\*
7. Views/Auth/\*
8. Views/Home/\*
9. Views/Post/\*
10. Views/Profile/\*
11. Views/Search/\*
12. Views/Components/\*
13. Utilities/\*

---

## 7) পরের ধাপের প্ল্যান (আগামী সেশনগুলোতে)

আগামী স্টেপগুলোতে আমরা একে একে deep details যোগ করব:

- [ ] KUET_TradeApp.swift full explanation
- [ ] ContentView.swift full explanation
- [ ] AuthViewModel.swift full explanation
- [ ] AuthService.swift full explanation
- [ ] ItemViewModel.swift full explanation
- [ ] PostItemViewModel.swift full explanation
- [ ] FirestoreService.swift full explanation
- [ ] StorageService.swift full explanation
- [ ] সব view file full explanation (one by one)
- [ ] Utilities full explanation

যখন detailed mode শুরু করব, প্রতিটি ফাইল সেকশনে থাকবে:

- Purpose
- Key properties
- Key functions
- UI behavior (যদি view হয়)
- Data flow in/out
- ওই ফাইল থেকে আসতে পারে এমন common interview/defense প্রশ্ন

---

## 8) গুরুত্বপূর্ণ কথা

এই প্রজেক্টে beginner-friendly MVVM pattern এবং Firebase integration পরিষ্কারভাবে ও consistent ভাবে ব্যবহার করা হয়েছে। group academic project হিসেবে এটা ভালো ও practical base.

---

## 9) Function-by-Function Detailed Explanation (শুরু)

নিচে আমরা ফাইল ধরে ধরে function/important property explain করছি:

- এটা কী কাজ করে
- input কী নেয়
- output কী দেয়
- ভিতরে কীভাবে কাজ করে
- কেন দরকার

### 9.1) KUET_TradeApp.swift

#### A) `application(_:didFinishLaunchingWithOptions:)`

**কোথায়:** `AppDelegate` class এর ভিতরে

**কাজ কী:**

- অ্যাপ চালু হওয়ার একদম শুরুতে Firebase initialize করে

**Input:**

- `application`: current UIApplication instance
- `launchOptions`: app launch context (notification/deep link ইত্যাদি, optional)

**Output:**

- `Bool` রিটার্ন করে
- `true` মানে launch setup সফল

**ভিতরে কীভাবে কাজ করে:**

1. `FirebaseApp.configure()` call হয়
2. Firebase config file (`GoogleService-Info.plist`) থেকে সেটিং পড়ে
3. Auth/Firestore/Storage use করার জন্য app প্রস্তুত হয়
4. শেষে `true` return হয়

**কেন দরকার:**

- এটা না করলে Firebase service call করার সময় app crash/failed হতে পারে

---

#### B) `var body: some Scene` (in `KUET_TradeApp`)

**কাজ কী:**

- অ্যাপের root scene define করে

**Input:**

- direct parameter নেয় না

**Output:**

- `some Scene` (এখানে `WindowGroup`)

**ভিতরে কীভাবে কাজ করে:**

1. `WindowGroup` তৈরি করে
2. প্রথম root view হিসেবে `ContentView()` inject করে
3. এখান থেকেই app UI flow শুরু হয়

**কেন দরকার:**

- SwiftUI app lifecycle এ এটা মূল entry UI point

---

#### C) `@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate`

**এটা function না, property-wrapper based bridge**

**কাজ কী:**

- SwiftUI lifecycle এর সাথে UIKit `AppDelegate` যুক্ত করে

**Input:**

- `AppDelegate.self` type

**Output:**

- runtime এ `AppDelegate` instance manage হয়

**কেন দরকার:**

- Firebase configure করার কাজটা ঐ delegate launch method এ চালানোর জন্য

---

### 9.2) ContentView.swift

#### A) `@StateObject private var authViewModel = AuthViewModel()`

**এটা function না, state owner property**

**কাজ কী:**

- `AuthViewModel`-এর lifecycle `ContentView` level এ hold করে

**Input:**

- `AuthViewModel()` initializer

**Output:**

- observable object instance

**ভিতরে কীভাবে কাজ করে:**

1. View প্রথমবার তৈরি হলে `AuthViewModel` create হয়
2. পরে view redraw হলেও একই instance ধরে রাখে
3. auth state change হলে UI re-render হয়

**কেন দরকার:**

- auth state app-wide gate হিসেবে কাজ করে, তাই stable instance লাগবে

---

#### B) `var body: some View`

**কাজ কী:**

- auth state অনুযায়ী কোন screen দেখাবে তা ঠিক করে

**Input:**

- direct function input নেই
- internally `authViewModel.isCheckingAuth`, `authViewModel.isLoggedIn` read করে

**Output:**

- `some View` (LaunchScreenView / MainTabView / LoginView)

**ভিতরে কীভাবে কাজ করে:**

1. `isCheckingAuth == true` হলে `LaunchScreenView()` দেখায়
2. না হলে `isLoggedIn == true` হলে `MainTabView(authViewModel: authViewModel)` দেখায়
3. অন্যথায় `LoginView(viewModel: authViewModel)` দেখায়
4. দুইটা `.animation(...)` দিয়ে state switch smooth করে

**কেন দরকার:**

- এই ফাইলটাই app-এর authentication gatekeeper

---

#### C) `.animation(.easeInOut(duration: 0.4), value: ...)`

**এটা modifier, pure function না**

**কাজ কী:**

- auth state change হলে screen transition smoother করে

**Input:**

- animation curve (`easeInOut`, `0.4s`)
- observed value (`isLoggedIn`, `isCheckingAuth`)

**Output:**

- animated view transitions

**ভিতরে কীভাবে কাজ করে:**

1. observed value change detect করে
2. নতুন view render animation সহ করে

**কেন দরকার:**

- হঠাৎ screen switch না হয়ে polished UX দেয়

---

### 9.3) Mini Data Flow (এই দুই ফাইল মিলিয়ে)

1. App start -> `application(_:didFinishLaunchingWithOptions:)` -> Firebase setup
2. `KUET_TradeApp.body` -> `ContentView()` root হিসেবে render
3. `ContentView` -> auth checking state দেখে launch অথবা login/main tabs দেখায়
4. user login করলে একই `authViewModel` main tabs-এ pass হয়

---

### 9.4) Viva/Defense Ready Questions (এই অংশ থেকে)

1. কেন `@StateObject` ব্যবহার করা হয়েছে, `@ObservedObject` না?

**উত্তর:** `@StateObject` ব্যবহার করা হয়েছে কারণ `AuthViewModel` lifecycle `ContentView` সাথে persist থাকতে হবে। `@StateObject` view recreate হলেও একই instance ধরে রাখে, কিন্তু `@ObservedObject` parent থেকে ইনজেক্ট করতে হয়। এখানে `AuthViewModel` app-level state, তাই `ContentView`-ই owner হবে।

---

2. Firebase configure কোথায় হচ্ছে এবং কেন launch phase-এ?

**উত্তর:** Firebase configure হচ্ছে `AppDelegate.application(_:didFinishLaunchingWithOptions:)` method এ। এটা app launch-এর একদম প্রথম phase, যখন `FirebaseApp.configure()` call হয়। এটা launch phase-এ করা দরকার কারণ Firebase services (Auth, Firestore, Storage) যেকোনো view/service আগে initialization দিতে হয়, নতুন কোনো request আসে তার আগে।

---

3. `ContentView`-কে কেন gatekeeper বলা হয়?

**উত্তর:** `ContentView` হলো app-এর authentication gate। এটাই decide করে user logged in কিনা:

- যদি `isCheckingAuth == true` → LaunchScreenView দেখায়
- যদি `isLoggedIn == true` → MainTabView দেখায়
- অন্যথায় → LoginView দেখায়

তাই এটা gatekeeper, যার থেকেই পুরো app flow control হয়।

---

4. `isCheckingAuth` আর `isLoggedIn` আলাদা state রাখার সুবিধা কী?

**উত্তর:** `isCheckingAuth`: app শুরু হওয়ার সময় যখন Firebase-কে জিজ্ঞাসা করা হচ্ছে user আছে কিনা, তখন true। `isLoggedIn`: Firebase respond দিয়েছে এবং user actually logged in আছে, তখন true। আলাদা রাখার সুবিধা: launch screen দেখানো যায় যখন checking চলছে, login screen দেখানো যায় যখন নিশ্চিত হয়েছে user logged out। ফলে loading state আলাদাভাবে handle করা যায়।

---

5. animation modifiers না দিলে UX-এ কী পরিবর্তন হবে?

**উত্তর:** Animation modifier না থাকলে screen switches হঠাৎ করে হবে (instant)। যেমন auth check শেষ হয়েই immediately LaunchScreenView গায়েব হবে, MainTabView যাবে। এতে user confused হতে পারে, মনে হবে app glitch করছে। Animation থাকলে smooth transition হয়, UX polished থাকে এবং user জানে change happening এ।

---

### 9.5) Progress Update

- [x] KUET_TradeApp.swift full explanation (function-level)
- [x] ContentView.swift full explanation (function-level)
- [x] MainTabView.swift full explanation (function-level)
- [ ] পরবর্তী: AuthViewModel.swift function-by-function

---

### 9.6) MainTabView.swift

#### A) `@ObservedObject var authViewModel: AuthViewModel`

**এটা function না, injected observable dependency**

**কাজ কী:**

- parent (`ContentView`) থেকে আসা auth state ব্যবহার করা

**Input:**

- `AuthViewModel` instance (constructor দিয়ে pass হয়)

**Output:**

- direct value return করে না; UI update trigger করে

**ভিতরে কীভাবে কাজ করে:**

1. logged-in user related data এখানে observable হিসেবে থাকে
2. `ProfileView` ও `MyAdsView`-এ এই object pass হয়

**কেন দরকার:**

- tabগুলোর মধ্যে consistent auth/user state রাখতে

---

#### B) `@StateObject private var itemViewModel = ItemViewModel()`

**এটা function না, local state owner**

**কাজ কী:**

- item data/search/filter state একবার create করে সব tab-এ share করা

**Input:**

- `ItemViewModel()` initializer

**Output:**

- shared observable state for Home/Post/MyAds tabs

**ভিতরে কীভাবে কাজ করে:**

1. MainTabView create হলে ItemViewModel তৈরি হয়
2. HomeView, PostItemView, MyAdsView এই একই instance use করে
3. ফলে tab change করলেও filter/data state continuity থাকে

**কেন দরকার:**

- প্রতিটা tab-এ আলাদা item state না করে single source of truth রাখা

---

#### C) `@StateObject private var networkMonitor = NetworkMonitor.shared`

**এটা singleton monitor bind করার state object**

**কাজ কী:**

- internet connection status observe করা

**Input:**

- `NetworkMonitor.shared`

**Output:**

- `isConnected` change হলে UI update

**কেন দরকার:**

- offline banner reactive ভাবে show/hide করার জন্য

---

#### D) `@State private var selectedTab: Int = 0`

**এটা selected tab index state**

**কাজ কী:**

- বর্তমানে কোন tab active তা track করা

**Input:**

- user tab tap করলে selection change হয়

**Output:**

- TabView selected page change

**কেন দরকার:**

- tab switch event detect করে haptic feedback দিতে

---

#### E) `var body: some View`

**কাজ কী:**

- main app shell (offline banner + tab navigation) render করা

**Input:**

- internal states: `networkMonitor.isConnected`, `selectedTab`
- dependencies: `authViewModel`, `itemViewModel`

**Output:**

- `some View` (VStack containing OfflineBanner + TabView)

**ভিতরে কীভাবে কাজ করে:**

1. উপরে `OfflineBannerView()` রাখে
2. banner-এ `.animation(..., value: networkMonitor.isConnected)` apply করে
3. নিচে `TabView(selection: $selectedTab)` তৈরি করে
4. চারটি tab define করে:

- `HomeView(itemViewModel: itemViewModel)` tag `0`
- `PostItemView(itemViewModel: itemViewModel)` tag `1`
- `MyAdsView(authViewModel: authViewModel, itemViewModel: itemViewModel)` tag `2`
- `ProfileView(authViewModel: authViewModel)` tag `3`

5. `.onChange(of: selectedTab)` এ light haptic trigger করে

**কেন দরকার:**

- login-এর পর পুরো app navigation experience এই screen থেকে control হয়

---

#### F) `.onChange(of: selectedTab) { _, _ in ... }`

**এটা event handler closure**

**কাজ কী:**

- tab পরিবর্তনের সাথে সাথে tactile feedback দেওয়া

**Input:**

- old এবং new tab value (এখানে use করা হয়নি)

**Output:**

- visible return নেই; side effect: haptic vibration

**ভিতরে কীভাবে কাজ করে:**

1. `UIImpactFeedbackGenerator(style: .light)` বানায়
2. `impactOccurred()` call করে

**কেন দরকার:**

- UI interaction feel improve করে

---

#### G) `PlaceholderTabView` (supporting view)

**এটা optional reusable placeholder component**

**কাজ কী:**

- future/empty tabs দ্রুত দেখানোর scaffold

**Important members:**

- `icon`, `title`, `subtitle`: display content
- `showSignOut`: sign-out button দেখাবে কি না
- `onSignOut`: button action callback
- `var body: some View`: static placeholder UI render

**কেন দরকার:**

- development phase-এ unfinished tab এর জন্য দ্রুত UI fallback

---

### 9.7) Mini Data Flow (MainTabView)

1. ContentView থেকে `authViewModel` inject হয়
2. MainTabView নিজে `itemViewModel` create করে এবং 3 tab-এ share করে
3. Home/Post/MyAds একই item source use করে
4. tab change হলে `selectedTab` update + haptic হয়
5. network offline হলে top banner animate হয়ে দেখায়

---

### 9.8) Viva/Defense Ready Questions (MainTabView)

1. কেন `itemViewModel` কে MainTabView level-এ রাখা হয়েছে?

**উত্তর:** `itemViewModel` MainTabView level-এ রাখা হয়েছে কারণ Home, Post, এবং MyAds তিনটি tab-ই একই item data নিয়ে কাজ করে। যদি প্রতিটা tab-এ আলাদা `itemViewModel` থাকত, তাহলে একটা tab-এ search/filter করলে অন্য tab-এ তা persist থাকত না। এভাবে single source of truth maintain হয় এবং tab switch করলেও filter state continuity থাকে।

---

2. HomeView/PostItemView/MyAdsView এর মধ্যে state sharing কীভাবে হচ্ছে?

**উত্তর:** State sharing হচ্ছে `itemViewModel` parameter pass করার মাধ্যমে। MainTabView যেই একটাই `itemViewModel` instance তৈরি করেছে, সেটাই তিনটি view-তে pass হচ্ছে:

- HomeView: read করে item list ও search/filter state দেখায়
- PostItemView: new item add করার সময় ItemViewModel থেকে category/sorting রেফারেন্স নেয়
- MyAdsView: seller-এর নিজের listing গুলো edit/delete করার জন্য ভাগ করা instance use করে

---

3. `@ObservedObject` vs `@StateObject` এখানে কেন আলাদা?

**উত্তর:** `@StateObject` মানে MainTabView নিজে `itemViewModel` তৈরি করছে এবং lifecycle control করছে। `@ObservedObject` মানে external থেকে আসা object শুধু observe করছি (যেমন `authViewModel` যা ContentView থেকে আসছে)। আলাদা আলাদা ব্যবহার করার কারণ: `itemViewModel` এর lifecycle MainTabView এর সাথে থাকবে, কিন্তু `authViewModel` এর lifecycle ContentView থেকে শুরু হয় এবং সেখানেই রাখা হয়েছে।

---

4. `selectedTab` track না করলে কোন behavior হারাবে?

**উত্তর:** `selectedTab` না থাকলে `onChange(of: selectedTab)` callback trigger হবে না, তাই haptic feedback আর দিতে পারব না। Tab tap করলেও কোনো tactile response থাকবে না। এছাড়াও `TabView(selection: $selectedTab)` binding কাজ করব না, তাই programmatically tab switch করতে পারব না (যদি কোনো view থেকে tab change করতে হতো)।

---

5. OfflineBannerView-এ animation value-based কেন?

**উত্তর:** `animation(.easeInOut(duration: 0.3), value: networkMonitor.isConnected)` করা হয়েছে কারণ যখন internet status দ্রুত বদলাতে থাকে (মোবাইল নেটওয়ার্ক fluctuation), তখন smooth transition দরকার। Value-based animation মানে শুধুমাত্র `isConnected` পরিবর্তন হলেই animation trigger হয়, অন্য কোনো state change বা body re-render হলে নয়। এতে অপ্রয়োজনীয় animations রোধ হয় এবং UX polish থাকে।

---

### 9.9) AuthViewModel.swift

এই ফাইল হলো authentication-এর brain। Login/Signup/Forgot Password/Sign Out + error handling + form validation সব এখানে।

#### A) `static let shared = AuthViewModel()`

**কাজ কী:**

- shared singleton access দেয়

**Input:**

- direct input নেই

**Output:**

- globally reusable `AuthViewModel` instance

**কেন দরকার:**

- কিছু জায়গায় (যেমন post flow) current user দ্রুত access করতে

---

#### B) `init()`

**কাজ কী:**

- object create হওয়ার সাথে সাথে auth listener start করে

**Input:**

- নেই

**Output:**

- object initialized state

**ভিতরে কীভাবে কাজ করে:**

1. `listenToAuthState()` call করে
2. Firebase auth state change observe করা শুরু হয়

---

#### C) `deinit`

**কাজ কী:**

- object destroy হওয়ার সময় auth listener remove করা

**Input:**

- নেই

**Output:**

- listener cleanup

**কেন দরকার:**

- memory leak বা duplicate listener avoid করতে

---

#### D) `private func listenToAuthState()`

**কাজ কী:**

- Firebase login/logout state observe করে local state update করা

**Input:**

- direct input নেই

**Output:**

- return কিছু দেয় না; side effect হিসেবে `isLoggedIn`, `isCheckingAuth`, `currentUser` update হয়

**ভিতরে কীভাবে কাজ করে:**

1. `AuthService.shared.addAuthStateListener` register করে
2. callback-এ `loggedIn` value পায়
3. main actor task এ `isLoggedIn` set করে
4. auth check শেষ হলে `isCheckingAuth = false`
5. logged in হলে `fetchUser()` call
6. logged out হলে `currentUser = nil`

---

#### E) `func fetchUser() async`

**কাজ কী:**

- current user profile Firestore থেকে fetch করা

**Input:**

- direct parameter নেই

**Output:**

- direct return নেই; `currentUser` update হয়

**ভিতরে কীভাবে কাজ করে:**

1. `AuthService.shared.fetchCurrentUser()` call করে
2. success হলে `currentUser` set
3. fail হলে fallback path চলে:

- Firebase Auth এর raw user থেকে `KTUser` বানায়
- minimal data დიয়েও app usable রাখে

4. error console-এ print করে

**কেন দরকার:**

- Firestore profile না পেলেও app crash না করে graceful degrade করে

---

#### F) `func login() async`

**কাজ কী:**

- email/password দিয়ে user sign in করা

**Input:**

- `loginEmail`, `loginPassword` (stored state fields)

**Output:**

- direct return নেই; success হলে auth listener state update করে

**ভিতরে কীভাবে কাজ করে:**

1. `validateLoginFields()` pass না করলে return
2. `isLoading = true`
3. `AuthService.shared.signIn(...)` call
4. success হলে `clearLoginFields()`
5. fail হলে `mapAuthError(error)` + `showErrorMessage(...)`
6. শেষে `isLoading = false`

---

#### G) `func signUp() async`

**কাজ কী:**

- নতুন user account create করা এবং profile save করা

**Input:**

- signup form fields (`signupName`, `signupEmail`, `signupPhone`, `signupDepartment`, `signupPassword`)

**Output:**

- direct return নেই; `currentUser` set হতে পারে

**ভিতরে কীভাবে কাজ করে:**

1. `validateSignupFields()` check
2. `isLoading = true`
3. `AuthService.shared.signUp(...)` call
4. success হলে returned user `currentUser`-এ set
5. `clearSignupFields()`
6. error হলে mapped message show
7. শেষে `isLoading = false`

---

#### H) `func resetPassword() async`

**কাজ কী:**

- forgot-password email পাঠানো

**Input:**

- `resetEmail`

**Output:**

- success হলে `resetEmailSent = true`

**ভিতরে কীভাবে কাজ করে:**

1. email trim করে
2. empty হলে error show
3. invalid format হলে error show
4. valid হলে `AuthService.shared.resetPassword(email:)`
5. success হলে UI success state (`resetEmailSent`) set

---

#### I) `func signOut()`

**কাজ কী:**

- current session logout করা

**Input:**

- নেই

**Output:**

- direct return নেই; local state clear হয়

**ভিতরে কীভাবে কাজ করে:**

1. `AuthService.shared.signOut()` try করে
2. success হলে `currentUser = nil`
3. login/signup form fields clear
4. fail হলে error message show

---

#### J) `private func validateLoginFields() -> Bool`

**কাজ কী:**

- login input valid কিনা check করা

**Input:**

- `loginEmail`, `loginPassword`

**Output:**

- `true` = valid, `false` = invalid

**Validation rules:**

1. email/password empty না
2. email valid format
3. password min length (`AppConstants.Validation.minPasswordLength`)

---

#### K) `private func validateSignupFields() -> Bool`

**কাজ কী:**

- signup form সব input verify করা

**Input:**

- সব signup fields

**Output:**

- `Bool`

**Validation rules:**

1. সব mandatory field non-empty
2. valid email
3. valid phone (10–14 digits rule)
4. password minimum length
5. password এবং confirm password same

---

#### L) `private func showErrorMessage(_ message: String)`

**কাজ কী:**

- UI alert state এক জায়গা থেকে set করা

**Input:**

- `message: String`

**Output:**

- direct return নেই; `errorMessage` এবং `showError` update হয়

---

#### M) `private func mapAuthError(_ error: Error) -> String`

**কাজ কী:**

- Firebase auth error code কে user-friendly message-এ convert করা

**Input:**

- `Error`

**Output:**

- `String` (displayable message)

**ভিতরে কীভাবে কাজ করে:**

1. `NSError` এ cast করে
2. domain `AuthErrorDomain` কিনা check করে
3. `AuthErrorCode` switch করে readable message return করে
4. unknown হলে `localizedDescription`

---

#### N) `private func clearLoginFields()`

**কাজ কী:**

- login form reset করা

**Input:**

- নেই

**Output:**

- `loginEmail = ""`, `loginPassword = ""`

---

#### O) `private func clearSignupFields()`

**কাজ কী:**

- signup form reset করা

**Input:**

- নেই

**Output:**

- signup সম্পর্কিত সব field empty string

---

#### P) `func clearResetFields()`

**কাজ কী:**

- forgot-password screen state reset করা

**Input:**

- নেই

**Output:**

- `resetEmail = ""`
- `resetEmailSent = false`

---

### 9.10) Mini Data Flow (AuthViewModel)

1. `init()` -> `listenToAuthState()` শুরু
2. user login/signup করলে service call হয়
3. Firebase auth state বদলালে listener `isLoggedIn` update করে
4. logged in হলে `fetchUser()` profile আনে
5. validation fail বা service fail হলে `showErrorMessage()` alert state set করে

---

### 9.11) Viva/Defense Ready Questions (AuthViewModel)

1. `login()` success হলে কেন সাথে সাথে `isLoggedIn = true` set করা হয়নি?

**উত্তর:** কারণ `login()` method শুধু `AuthService.shared.signIn()` call করে, auth state change handling নয়। Firebase auth state change হলে automatically listener activate হয় (যা `listenToAuthState()` callback-এ register করা আছে), সেখানেই `isLoggedIn = true` set হয়। এভাবে করার সুবিধা: যদি কেউ somewhere else থেকে logout করে, তাহলেও listener সেটা detect করতে পারে এবং UI update হবে। Single source of truth।

---

2. `fetchUser()`-এ fallback user তৈরির প্রয়োজন কেন?

**উত্তর:** কারণ তখন ক্রমেই Firestore profile ডকুমেন্ট না থাকতে পারে (network error, first login এবং save delay, ইত্যাদি)। এরকম situation-এ app crash করার বদলে graceful degrade করতে হয়। Firebase Auth-এ তো ইউজার থাকছে, তাই Firebase Auth থেকে minimal info (uid, email) নিয়ে temporary `KTUser` object তৈরি করা হয়, যাতে app কাজ করতে থাকে। এরপর যখন নেটওয়ার্ক আসে বা retry হয়, তখন সঠিক profile load হয়ে যায়।

---

3. `mapAuthError()` না থাকলে UX-এ কী সমস্যা হতো?

**উত্তর:** `mapAuthError()` না থাকলে Firebase error code (যেমন `user-not-found`, `wrong-password`, `too-many-requests`) directly user-কে দেখানো হতো। এরকম technical error messages user-এর কাছে confusing লাগে এবং unprofessional দেখায়। `mapAuthError()` থাকার কারণে readable Bengali message (যেমন "এই ইমেইল দিয়ে কোনো অ্যাকাউন্ট নেই") দেখানো যায়, যা user-friendly এবং auth troubleshooting easy করে।

---

4. `validateSignupFields()`-এ কোন ruleগুলো business rule হিসেবে ধরা হয়েছে?

**উত্তর:** বেশিরভাগ rules technical (email format, password length), কিন্তু pure business rules:

- **Phone validation (10-14 digits)**: KUET student ID এর সাথে phone match করার প্রয়োজনীয়তা থেকে আসা (country code variations handle করতে)
- **Department mandatory**: Marketplace-এ user categorizing এর জন্য department info critical
- **Password = Confirm Password check**: Double-entry security practice, data entry error reduce করতে
  এই rules technically database constraint না করে, business logic-এ করা হয়েছে যাতে user feedback দিতে পারি।

---

5. `deinit`-এ listener remove করা কেন গুরুত্বপূর্ণ?

**উত্তর:** `AuthViewModel` যখনই destroy হয় (যেমন logout পরে, বা view dismiss হয়), listener-টা automatically active থাকলে memory leak হতে থাকে। একই listener multiple times register হলে duplicate callbacks trigger হতে থাকে, যা performance degrade করে এবং weird behavior create করে। `deinit`-এ `AuthService.shared.removeAuthStateListener(listenerHandle)` call করে listener explicitly cleanup করা হয়েছে, যা best practice।

---

### 9.12) Progress Update

- [x] KUET_TradeApp.swift full explanation (function-level)
- [x] ContentView.swift full explanation (function-level)
- [x] MainTabView.swift full explanation (function-level)
- [x] AuthViewModel.swift full explanation (function-level)
- [ ] পরবর্তী: AuthService.swift function-by-function

---

### 9.13) AuthService.swift

এই ফাইলটি Firebase Auth + Firestore user document-এর low-level service layer।
AuthViewModel এই service call করে authentication কাজ সম্পন্ন করে।

#### A) `static let shared = AuthService()`

**কাজ কী:**

- singleton service instance দেয়

**Input:**

- direct input নেই

**Output:**

- globally reusable `AuthService` object

**কেন দরকার:**

- app জুড়ে একই auth/db handle ব্যবহার করতে

---

#### B) `private init() {}`

**কাজ কী:**

- বাইরের code যেন নতুন instance বানাতে না পারে

**Input/Output:**

- direct কিছু নেই

**কেন দরকার:**

- singleton pattern enforce করতে

---

#### C) `var currentUserID: String?`

**এটা computed property**

**কাজ কী:**

- current logged-in user-এর UID return করা

**Input:**

- নেই

**Output:**

- `String?` (logged in না থাকলে `nil`)

**ভিতরে কীভাবে কাজ করে:**

1. `auth.currentUser?.uid` read করে
2. optional UID return করে

---

#### D) `var isLoggedIn: Bool`

**এটা computed property**

**কাজ কী:**

- user logged in আছে কি না quick check

**Input:**

- নেই

**Output:**

- `Bool`

**ভিতরে কীভাবে কাজ করে:**

1. `auth.currentUser != nil` evaluate করে
2. true/false return করে

---

#### E) `func signUp(name:email:phone:department:password:) async throws -> KTUser`

**কাজ কী:**

- নতুন user account create করে
- Firebase Auth profile update করে
- Firestore-এ user document save করে

**Input:**

- `name: String`, `email: String`, `phone: String`, `department: String`, `password: String`

**Output:**

- success হলে `KTUser`, failure হলে `throws`

**ভিতরে কীভাবে কাজ করে:**

1. `auth.createUser(withEmail:password:)` দিয়ে auth account create
2. returned `uid` নেয়
3. `createProfileChangeRequest()` দিয়ে Firebase Auth profile-এর displayName set
4. `commitChanges()` call করে profile update persist করে
5. local `KTUser` object বানায়
6. `db.collection("users").document(uid).setData(from: newUser)` দিয়ে Firestore-এ save করে
7. `newUser` return করে

**কেন দরকার:**

- শুধু Auth account না, app-এর own user profile dataও একই সাথে persist করতে

---

#### F) `func signIn(email:password:) async throws`

**কাজ কী:**

- existing user login করা

**Input:**

- `email: String`, `password: String`

**Output:**

- direct return নেই (`Void`), fail হলে `throws`

**ভিতরে কীভাবে কাজ করে:**

1. `auth.signIn(withEmail:password:)` call
2. success হলে Firebase currentUser set হয়
3. এরপর listener (viewmodel side) auth state update handle করে

---

#### G) `func signOut() throws`

**কাজ কী:**

- current user logout করা

**Input:**

- নেই

**Output:**

- direct return নেই, fail হলে `throws`

**ভিতরে কীভাবে কাজ করে:**

1. `auth.signOut()` call
2. success হলে current session clear

---

#### H) `func resetPassword(email:) async throws`

**কাজ কী:**

- password reset email trigger করা

**Input:**

- `email: String`

**Output:**

- direct return নেই, fail হলে `throws`

**ভিতরে কীভাবে কাজ করে:**

1. `auth.sendPasswordReset(withEmail:)` call
2. Firebase ঐ email-এ reset link পাঠায়

---

#### I) `func fetchCurrentUser() async throws -> KTUser?`

**কাজ কী:**

- Firestore থেকে logged-in user profile document fetch করা

**Input:**

- direct parameter নেই

**Output:**

- `KTUser?`, logged in না থাকলে `nil`, firestore/decode fail হলে `throws`

**ভিতরে কীভাবে কাজ করে:**

1. `currentUserID` guard করে UID নেয়
2. `users/{uid}` document fetch করে
3. `snapshot.data(as: KTUser.self)` দিয়ে decode করে
4. decoded user return করে

---

#### J) `func addAuthStateListener(completion:) -> AuthStateDidChangeListenerHandle`

**কাজ কী:**

- auth state change observer register করা

**Input:**

- `completion: (Bool) -> Void`

**Output:**

- `AuthStateDidChangeListenerHandle` (পরে remove করার জন্য)

**ভিতরে কীভাবে কাজ করে:**

1. `auth.addStateDidChangeListener` register করে
2. Firebase user nil/non-nil দেখে `completion(user != nil)` call করে

**কেন দরকার:**

- UI-তে realtime login/logout gate switch করতে

---

#### K) `func removeAuthStateListener(_ handle:)`

**কাজ কী:**

- previously added auth listener remove করা

**Input:**

- `handle: AuthStateDidChangeListenerHandle`

**Output:**

- direct return নেই

**ভিতরে কীভাবে কাজ করে:**

1. `auth.removeStateDidChangeListener(handle)` call করে

---

### 9.14) Mini Data Flow (AuthService)

1. Signup: `createUser` -> profile displayName update -> Firestore user doc save
2. Login: `signIn` -> Firebase currentUser set -> listener callback -> UI state update
3. Logout: `signOut` -> listener callback -> app login screen এ ফিরে যায়
4. Profile load: `fetchCurrentUser` -> `users/{uid}` fetch -> decode `KTUser`

---

### 9.15) Viva/Defense Ready Questions (AuthService)

1. কেন signup-এর সময় Auth + Firestore দুই জায়গায় data save করা হয়?

**উত্তর:** Firebase Auth-এ user authentication (login check, password verify) survive হয়, কিন্তু Auth-এ custom user data (phone, department ইত্যাদি) save রাখা ভালো practice না। তাই Firestore-এ separate user document রেখে business data maintain করা হয়। এতে সুবিধা: Auth থেকে email/uid quick access, Firestore থেকে detailed profile access। দুইটা decouple থাকায় যেকোনো একটা update/query করা স্বাধীন থাকে এবং consistency maintain করা (duplicate write) easy হয়।

---

2. `currentUserID` nil হলে `fetchCurrentUser()`-এ কী হবে?

**উত্তর:** `fetchCurrentUser()` method-এ প্রথম লাইনেই `guard let uid = currentUserID else { return nil }` আছে। তাই nil হলে code সাথে সাথে nil return করে দেয়, Firestore query run হয় না। এটা optimization: unnecessary database call avoid হয় এবং error prevention, কারণ nil uid দিয়ে query করলে error throw হতো।

---

3. listener handle return করা কেন দরকার?

**উত্তর:** `addAuthStateListener` যখন listener register করে, Firebase একটা handle বা reference দেয়। এই handle-টা ধরে রাখতে হয় যাতে later পরে `removeAuthStateListener(handle)` call করে listener cleanup করতে পারি। Handle return না করলে, listener remove করার কোনো উপায় থাকত না, তাই memory leak হতো। AuthViewModel-এর `deinit`-এ এই handle দিয়েই listener remove হয়।

---

4. `signIn()` method কেন user object return করছে না?

**উত্তর:** `signIn()` শুধু Firebase-কে বলে "এই email/password দিয়ে এই user-কে login করিয়ে দাও"। Firebase সেটা সফল করলে Firebase-এর internal `currentUser` set হয়ে যায়। এরপর `listenToAuthState()` callback automatically trigger হয় (যা দিয়ে UI গত change হয়)। আলাদা user object return না করার reason: state মেইনটেইন একটি জায়গায় (Firebase) থাকে, ডুপ্লিকেট data avoid হয়। ভিউমডেল listener-এর মাধ্যমে জানতে পারে login success হয়েছে।

---

5. Firebase Auth profile আর Firestore user profile-এর মধ্যে পার্থক্য কী?

**উত্তর:**

- **Firebase Auth profile**: Built-in (UID, email, password hash, displayName, profilePicURL). Fast auth check এর জন্য optimized। Password change, email change auth-related tasks এখানে।
- **Firestore user profile**: Custom document (phone, department, address, bio, createdAt, updatedAt ইত্যাদি)। Business data store করতে ব্যবহার।
- **কেন দুইটা**: Auth profile এ custom fields store করা ভালো practice না এবং complicated। তাই Firestore-এ full user profile maintain করা হয়, যেখানে search, filter, extend করা সহজ।

---

### 9.16) FirestoreService.swift

এই ফাইলটি items collection-এর CRUD এবং listing query logic handle করে।
ItemViewModel, MyAdsView, Post/Edit flow এই service-এর উপর নির্ভর করে।

#### A) `static let shared = FirestoreService()`

**কাজ কী:**

- singleton instance provide করা

**Input:**

- নেই

**Output:**

- global `FirestoreService` object

---

#### B) `private init() {}`

**কাজ কী:**

- singleton enforce করা

**Input/Output:**

- direct কিছু নেই

---

#### C) `private var itemsCollection: CollectionReference`

**এটা computed property**

**কাজ কী:**

- Firestore-এর items collection reference reuse করা

**Input:**

- নেই

**Output:**

- `CollectionReference` (`db.collection("items")`)

**কেন দরকার:**

- বারবার hardcoded path না লিখে centralized reference রাখা

---

#### D) `func createItem(_ item: Item) async throws -> String`

**কাজ কী:**

- নতুন item document তৈরি করা

**Input:**

- `item: Item`

**Output:**

- success হলে created document ID (`String`), fail হলে `throws`

**ভিতরে কীভাবে কাজ করে:**

1. `itemsCollection.addDocument(from: item)` call করে
2. Firestore document তৈরি হয়
3. `documentID` return করে

---

#### E) `func fetchAllItems() async throws -> [Item]`

**কাজ কী:**

- সব item fetch করে available item list return করা

**Input:**

- নেই

**Output:**

- `[Item]`

**ভিতরে কীভাবে কাজ করে:**

1. `itemsCollection.getDocuments()` থেকে snapshot আনে
2. প্রতিটি doc `Item`-এ decode করার চেষ্টা করে (`compactMap`)
3. `isAvailable == true` item filter করে
4. `createdAt` descending sort করে return দেয়

**নোট:**

- filter/sort client-side করা হচ্ছে

---

#### F) `func fetchItems(byCategory:) async throws -> [Item]`

**কাজ কী:**

- নির্দিষ্ট category-এর items আনা

**Input:**

- `category: ItemCategory`

**Output:**

- `[Item]`

**ভিতরে কীভাবে কাজ করে:**

1. Firestore query: `whereField("category", isEqualTo: category.rawValue)`
2. documents decode করে
3. available item filter করে
4. newest-first sort করে return দেয়

---

#### G) `func fetchUserItems(userID:) async throws -> [Item]`

**কাজ কী:**

- নির্দিষ্ট seller/user-এর সব ad আনা (My Ads এর জন্য)

**Input:**

- `userID: String`

**Output:**

- `[Item]`

**ভিতরে কীভাবে কাজ করে:**

1. query: `whereField("sellerID", isEqualTo: userID)`
2. decode করে item list তৈরি
3. created date descending sort
4. return

**নোট:**

- এখানে sold+active দুটোই আসে, যাতে seller manage করতে পারে

---

#### H) `func fetchItem(byID:) async throws -> Item?`

**কাজ কী:**

- single item details fetch করা

**Input:**

- `id: String` (document ID)

**Output:**

- `Item?`

**ভিতরে কীভাবে কাজ করে:**

1. `itemsCollection.document(id).getDocument()`
2. document data `Item`-এ decode
3. decoded object return

---

#### I) `func updateItem(_ item:) async throws`

**কাজ কী:**

- existing item document update করা

**Input:**

- `item: Item` (must include `id`)

**Output:**

- direct return নেই, fail হলে `throws`

**ভিতরে কীভাবে কাজ করে:**

1. `item.id` guard করে
2. id না থাকলে `FirestoreError.missingID` throw
3. `setData(from: item, merge: true)` দিয়ে update

**কেন merge true:**

- document overwrite না করে fields update preserve করতে

---

#### J) `func deleteItem(byID:) async throws`

**কাজ কী:**

- item document delete করা

**Input:**

- `id: String`

**Output:**

- direct return নেই

**ভিতরে কীভাবে কাজ করে:**

1. `itemsCollection.document(id).delete()` call

---

#### K) `func toggleAvailability(itemID:isAvailable:) async throws`

**কাজ কী:**

- item active/sold status toggle করা

**Input:**

- `itemID: String`, `isAvailable: Bool`

**Output:**

- direct return নেই

**ভিতরে কীভাবে কাজ করে:**

1. target document select করে
2. `updateData` দিয়ে দুই field update:
   - `isAvailable`
   - `updatedAt = Timestamp(date: Date())`

**কেন দরকার:**

- My Ads থেকে mark sold/relist action support করার জন্য

---

#### L) `enum FirestoreError: LocalizedError`

**কাজ কী:**

- service-level custom error type define করা

**Cases:**

- `missingID`
- `encodingFailed`
- `decodingFailed`

---

#### M) `var errorDescription: String?`

**কাজ কী:**

- custom error-এর জন্য readable message return করা

**Input:**

- current enum case

**Output:**

- `String?` user-friendly error text

---

### 9.17) Mini Data Flow (FirestoreService)

1. Post flow -> `createItem` -> নতুন doc তৈরি
2. Home flow -> `fetchAllItems` -> available items list
3. My Ads flow -> `fetchUserItems` -> seller-specific list
4. Edit flow -> `updateItem`
5. Delete flow -> `deleteItem`
6. Sold/Relist flow -> `toggleAvailability`

---

### 9.18) Viva/Defense Ready Questions (FirestoreService)

1. `fetchAllItems()`-এ filtering/sorting client-side করার impact কী?

**উত্তর:** Client-side filtering-এর সুবিধা: ছোট dataset-এ simple, code লাখানো কম, query cost কম। কিন্তু disadvantage: সব item একবার download করতে হয় (যেমন 10000 items), তারপর filter করা হয়। বড় dataset-এ slow এবং bandwidth waste। Production-এ better practice: Firestore composite index দিয়ে server-side filtering করা (যেমন `category == "Books" AND price <= 500`), তাহলে শুধু relevant items আসে।

---

2. `updateItem()`-এ `merge: true` কেন ব্যবহার করা হয়েছে?

**উত্তর:** `merge: true` মানে existing document-এর অন্য fields গুলো touch না করে শুধু provided fields update হবে। `merge: false` হলে document পুরা overwrite হয়ে যেত, আর যে fields provide করা হয়নি সেগুলো delete হয়ে যেত। যেমন item edit করার সময় শুধু title আর description পরিবর্তন হচ্ছে, কিন্তু `createdAt`, `sellerID`, `imageURLs` বাকি fields merge:true থাকায় preserve থাকে।

---

3. `fetchUserItems()` কেন sold items-ও return করে?

**উত্তর:** কারণ My Ads screen-এ seller দেখতে চায় both active এবং sold listings। Active items এডিট করতে পারে, sold items reactivate করতে পারে। যদি শুধু available items return করা হতো, তাহলে একবার sold হওয়ার পর seller ঐ item আর দেখতে পেত না, যা UX-এ খারাপ। Seller-এর সম্পূর্ণ history পেতে সব status items আসা দরকার।

---

4. `toggleAvailability()`-এ `updatedAt` update করা কেন দরকার?

**উত্তর:** `updatedAt` timestamp রাখার প্রয়োজন:

- **Audit trail**: কখন item status বদলেছে তার trace থাকে
- **Sorting**: newest updates প্রথমে দেখাতে পারি
- **UI logic**: যেমন recently updated items stamp দেখাতে পারি "Just sold" ইত্যাদি
- **Refresh optimization**: app যখন sync করে, এই timestamp দিয়ে incremental update করতে পারি

---

5. custom `FirestoreError` cases কোন কোন scenario cover করে?

**উত্তর:**

- `missingID`: যখন `updateItem()` পায় item object কিন্তু id field empty। ঐ case-এ কোন document identify করা যায় না।
- `encodingFailed`: Codable encode करते সময় fail হলে (যেমন অপ্রত্যাশিত data type)
- `decodingFailed`: Firestore document decode করতে fail হলে (যেমন schema mismatch, missing required field)
  এই custom errors UserDefaults ignore না করে, app-এ error handling এ transparent থাকে এবং UI-তে user-friendly message দেখানো যায়।

---

### 9.19) Progress Update

- [x] KUET_TradeApp.swift full explanation (function-level)
- [x] ContentView.swift full explanation (function-level)
- [x] MainTabView.swift full explanation (function-level)
- [x] AuthViewModel.swift full explanation (function-level)
- [x] AuthService.swift full explanation (function-level)
- [x] FirestoreService.swift full explanation (function-level)
- [x] StorageService.swift full explanation (function-level)
- [x] ItemViewModel.swift full explanation (function-level)
- [ ] পরবর্তী: PostItemViewModel.swift function-by-function

---

### 9.20) StorageService.swift

এই ফাইল image upload/delete সম্পর্কিত Firebase Storage operations handle করে।
PostItemViewModel ও Edit flow এই service ব্যবহার করে।

#### A) `static let shared = StorageService()`

**কাজ কী:**

- singleton storage service instance দেয়

**Input/Output:**

- direct input নেই, global `StorageService` object দেয়

---

#### B) `private init() {}`

**কাজ কী:**

- singleton enforce করা

---

#### C) `func uploadImage(_ image:path:) async throws -> String`

**কাজ কী:**

- single image upload করে downloadable URL return করা

**Input:**

- `image: UIImage`
- `path: String` (storage path)

**Output:**

- success হলে `String` download URL
- fail হলে `throws`

**ভিতরে কীভাবে কাজ করে:**

1. `image.jpegData(compressionQuality: 0.5)` দিয়ে compress করে
2. compression fail হলে `StorageError.compressionFailed`
3. `storage.reference().child(path)` reference তৈরি করে
4. metadata contentType `image/jpeg` set করে
5. `putDataAsync` দিয়ে upload করে
6. `downloadURL()` নিয়ে absolute string return করে

**কেন দরকার:**

- Firestore-এ image binary না রেখে lightweight URL save করতে

---

#### D) `func uploadImages(_ images:folderPath:) async throws -> [String]`

**কাজ কী:**

- multiple image sequentially upload করা

**Input:**

- `images: [UIImage]`
- `folderPath: String`

**Output:**

- `[String]` (সব uploaded image URL)

**ভিতরে কীভাবে কাজ করে:**

1. empty `urls` array নেয়
2. loop-এ প্রতিটি image এর জন্য unique path বানায়:
   - `image_<index>_<uuid>.jpg`
3. internal `uploadImage(...)` call করে
4. পাওয়া URL array-তে append করে
5. শেষে URLs return

**নোট:**

- sequential upload হওয়ায় code সহজ, তবে অনেক image হলে একটু সময় বেশি লাগতে পারে

---

#### E) `func deleteImage(url:) async throws`

**কাজ কী:**

- single image URL থেকে storage object delete করা

**Input:**

- `url: String`

**Output:**

- direct return নেই

**ভিতরে কীভাবে কাজ করে:**

1. `storage.reference(forURL: url)` থেকে reference নেয়
2. `ref.delete()` call করে

---

#### F) `func deleteImages(urls:) async throws`

**কাজ কী:**

- multiple images delete করা

**Input:**

- `urls: [String]`

**Output:**

- direct return নেই

**ভিতরে কীভাবে কাজ করে:**

1. loop করে প্রতিটি URL-এ `deleteImage(url:)` call
2. যেকোন delete fail হলে throw হতে পারে

---

#### G) `enum StorageError: LocalizedError`

**কাজ কী:**

- custom storage-related error cases define করা

**Cases:**

- `compressionFailed`
- `uploadFailed`
- `downloadURLFailed`

---

#### H) `var errorDescription: String?`

**কাজ কী:**

- error case অনুযায়ী readable message return করা

**Output:**

- optional readable string

---

### 9.21) Mini Data Flow (StorageService)

1. Post/Edit form থেকে images আসে
2. `uploadImages` -> প্রতিটি image upload -> URL list
3. URL list Firestore item document-এ save হয়
4. Edit/Delete এ removed image URL থাকলে `deleteImages` run হয়

---

### 9.22) Viva/Defense Ready Questions (StorageService)

1. কেন image compress করে upload করা হচ্ছে?

**উত্তর:** Image compression-এর উদ্দেশ্য:

- **Bandwidth save**: 5MB photo compress করে 500KB করলে 10 গুণ ডাটা সেভ, user-এর নেটওয়ার্ক fast থাকে
- **Storage cost**: Firebase Storage billing-এ per-GB charge করে, compression-এ খরচ কমে
- **Upload speed**: compress size ছোট হওয়ায় upload fast হয়, user অপেক্ষা কম করে
- `compressionQuality: 0.5`: 50% quality-তে ভিজ্যুয়ালি acceptable থাকে কিন্তু filesize নাটকীয় কমে
- trade-off: quality slightly lower, কিন্তু marketplace app-এ perfect image না লাগার কারণে acceptable

---

2. URL-based storage design-এর সুবিধা কী?

**উত্তর:** URL-based approach মানে Firestore document-এ actual image binary না রেখে শুধু URL string রেখে দেওয়া। সুবিধা:

- **Firestore size efficient**: Document-এ binary data থাকলে very heavy হয়, URL string ছোট (50-100 bytes)
- **Performance**: item list fetch করার সময় হালকা (metadata + URLs আসে), binary image না আসায় fast
- **Flexibility**: image URL থেকে direct download করা যায় বা CDN-এর মাধ্যমে optimize করা যায়
- **Security**: Storage rules দিয়ে asset access control করা যায়, Firestore rules থেকে independent
- **Scalability**: image separate place থেকে serve হয় (Storage), যাতে Firestore contention না থাকে

---

3. upload sequence parallel না হওয়ায় trade-off কী?

**উত্তর:** Sequential upload মানে একটা image একবার পুরা upload হওয়ার পর পরবর্তী শুরু হয়।

- **Disadvantage**: যদি 3টি image আছে এবং প্রতিটি 5 সেকেন্ড লাগে, তাহলে total 15 সেকেন্ড ধরে লাগে (parallel হলে ~5 সেকেন্ড)।
- **Advantage**: code simple, error handling straightforward, memory efficient (সব image একসাথে load না করে one-by-one)।
- **Trade-off**: mobile app context-এ acceptable চলে কারণ user-এ সাধারণ 2-3 টা image upload করে। Production app-এ parallel upload implement করা যেত (Promise.all style), তবে extra complexity যোগ হয়।

---

4. delete করার সময় URL reference কেন দরকার?

**উত্তর:** Firebase Storage-এ file identify করার জন্য reference দরকার। `storage.reference(forURL: url)` মানে সেই URL-টা যে এস3 পথে store আছে, সেই পথটা access করা। URL থেকে path extract করে reference নেওয়া, তারপর delete করা। কারণ:

- **URL uniquely identifies**: প্রতিটা uploaded file এর URL unique
- **Reference থেকে delete**: `ref.delete()` দিয়ে storage থেকে file physically remove হয়, তাহলে URL further broken link না থেকে memory free হয়

---

5. StorageError cases কোন কোন scenario cover করে?

**উত্তর:**

- `compressionFailed`: UIImage.jpegData() fail হলে (memory issue, corrupted image ইত্যাদি)
- `uploadFailed`: Firebase Storage upload interrupt/network error
- `downloadURLFailed`: uploadedDocument reference এ downloadURL() call fail হলে (যেমন permission issue)
  এই three main failure points app-এ cover করে, যাতে UI-তে proper error message দেখানো যায় এবং user জানে কী সমস্যা হয়েছে।

---

### 9.23) ItemViewModel.swift

এই ফাইল Home listing, filter, search, sort এবং refresh state control করে।

#### A) `init()`

**কাজ কী:**

- view model তৈরি হলেই initial item load trigger করা

**Input:**

- নেই

**Output:**

- direct return নেই

**ভিতরে কীভাবে কাজ করে:**

1. `Task { await loadItems() }` run করে
2. asynchronous ভাবে data fetch শুরু হয়

---

#### B) `func loadItems() async`

**কাজ কী:**

- backend থেকে items load করে local state-এ রাখা

**Input:**

- নেই

**Output:**

- direct return নেই
- side effect: `allItems`, `filteredItems`, loading/error flags update

**ভিতরে কীভাবে কাজ করে:**

1. `isLoading = allItems.isEmpty` (first load-এ skeleton দেখানোর জন্য)
2. `FirestoreService.shared.fetchAllItems()` call
3. success হলে `allItems = items`
4. `applyFilters()` run করে filtered list build
5. fail হলে `errorMessage` set + `showError = true`
6. শেষে `isLoading = false`, `isRefreshing = false`

---

#### C) `func refresh() async`

**কাজ কী:**

- pull-to-refresh logic চালানো

**Input:**

- নেই

**Output:**

- direct return নেই

**ভিতরে কীভাবে কাজ করে:**

1. `isRefreshing = true`
2. `loadItems()` call করে

---

#### D) `func applyFilters()`

**কাজ কী:**

- category/search/price/sort apply করে final list তৈরি করা

**Input:**

- internal states:
  - `allItems`
  - `selectedCategory`
  - `searchText`
  - `minPrice`, `maxPrice`
  - `selectedSort`

**Output:**

- `filteredItems` update

**ভিতরে কীভাবে কাজ করে:**

1. `result = allItems`
2. category selected থাকলে filter
3. search text থাকলে title/description/seller/category-তে case-insensitive match
4. min/max price parse করে range filter
5. selected sort অনুযায়ী sort
6. `filteredItems = result`

**কেন দরকার:**

- UI থেকে filter state change হলেই centralized logic চালাতে

---

#### E) `func clearFilters()`

**কাজ কী:**

- সব filter default state-এ reset করা

**Input:**

- নেই

**Output:**

- filter states reset (search/category/sort/price)

**ভিতরে কীভাবে কাজ করে:**

1. `searchText = ""`
2. `selectedCategory = nil`
3. `selectedSort = .newest`
4. `minPrice = ""`, `maxPrice = ""`

**নোট:**

- যেহেতু didSet-এ `applyFilters()` আছে, state change হলেই list auto-update হয়

---

#### F) `var hasActiveFilters: Bool`

**কাজ কী:**

- কোনো filter active আছে কি না check করা

**Input:**

- current filter states

**Output:**

- `Bool`

---

#### G) `var activeFilterCount: Int`

**কাজ কী:**

- মোট কয় ধরনের filter active তা count করা

**Input:**

- filter states

**Output:**

- `Int`

**কেন দরকার:**

- UI badge-এ active filter count দেখাতে

---

#### H) `var itemCount: Int`

**কাজ কী:**

- filtered item count return করা

**Output:**

- `Int` (`filteredItems.count`)

---

#### I) `var isEmpty: Bool`

**কাজ কী:**

- empty state দেখাবে কি না নির্ধারণ করা

**Output:**

- `Bool` (`filteredItems.isEmpty && !isLoading`)

---

#### J) `var priceRangeDescription: String?`

**কাজ কী:**

- min/max price filter কে human-readable label বানানো

**Input:**

- `minPrice`, `maxPrice`

**Output:**

- `String?` যেমন "৳200 – ৳500", "৳500+", "Up to ৳300" বা nil

---

#### K) Filter didSet triggers (`searchText`, `selectedCategory`, `selectedSort`, `minPrice`, `maxPrice`)

**এগুলো function না, reactive hooks**

**কাজ কী:**

- filter field পরিবর্তনের সাথে সাথে `applyFilters()` auto run

**কেন দরকার:**

- আলাদা apply button ছাড়াই live filtering UX পেতে

---

### 9.24) Mini Data Flow (ItemViewModel)

1. init -> `loadItems()`
2. `allItems` fetch হওয়ার পর `applyFilters()` run
3. UI-তে filter field change -> didSet -> `applyFilters()`
4. final list `filteredItems` এ যায়
5. UI `itemCount`, `hasActiveFilters`, `isEmpty` ব্যবহার করে render করে

---

### 9.25) Viva/Defense Ready Questions (ItemViewModel)

1. filter fields-এ didSet ব্যবহার করার সুবিধা কী?

**উত্তর:** didSet observable hook মানে যখনই filter value change হয়, automatically `applyFilters()` চলে। সুবিধা:

- **Live filtering**: separate "Apply" button না থাকায় immediate feedback মেলে, user typing করছে আর items real-time update হচ্ছে
- **No duplicate logic**: একবার didSet মেকানিজমে logic রাখলে, সব filter field-এ reuse হয়
- **Reactive pattern**: MVVM-এ state change automatically derived state update করা best practice
- **Performance**: applyFilters() intelligent করে, যা শুধু relevant items process করে

---

2. `isLoading = allItems.isEmpty` logic কেন useful?

**উত্তর:** প্রথম load-এ app launch করলে `allItems` সবসময় empty থাকে, তাই `isLoading = true` হয়, skeleton দেখায়। পরবর্তী refresh-এ `allItems` আছে (পূর্ববর্তী data), তাই `isLoading = false` হয়ে যায়, skeleton দেখায় না। এর মানে:

- **First load**: skeleton placeholder দেখানো (better UX than sudden content)
- **Refresh**: previous data থাকায় immediately দেখা যায়, skeleton নয় (smooth UX)
- **Network retry**: fail হলেই `isLoading = true` আর retry user-কে loading state দেয়

---

3. `allItems` আর `filteredItems` দুটো list রাখার কারণ কী?

**উত্তর:** Two-list pattern logic separation-এর জন্য।

- `allItems`: backend থেকে আসা raw, unfiltered items
- `filteredItems`: UI-তে actually দেখানোর list (filter/search/sort applied)
- কারণ: filter state change হলে পুরা Firestore query না করে (expensive), `allItems` থেকেই apply করা যায় (fast)
- পরে আরো filter add হলে (যেমন availability, rating), `allItems` থেকেই চেইন করা যায়
- single list হলে original data হারিয়ে যেত, revert করতে পুরা fetch লাগত

---

4. client-side filter/sort এর সীমাবদ্ধতা কী?

**উত্তর:** Client-side:

- `fetchAllItems()` সব item (1000+) একবার আনে, bandwidth বেশি
- বড় dataset-এ filter করা slow (user device এ processing)
- Performance issue যখন items অনেক বেশি
- Better: Firestore composite indices দিয়ে server-side query করা (যেমন `category && price <= X`), তাহলে relevant items শুধু আসে
- Trade-off: ছোট dataset-এ client-side simple এবং sufficient, production-এ optimize করতে পারি

---

5. `isEmpty`-তে `!isLoading` condition কেন দরকার?

**উত্তর:** `isEmpty = filteredItems.isEmpty && !isLoading` মানে:

- Load হওয়ার সময় empty state দেখাতে এড়ানো (ইতিমধ্যে loading skeleton দেখাচ্ছি)
- শুধু যখন `isLoading = false` এবং `filteredItems` empty, তখনই "No items found" দেখানো
- থাকলে load-এর সময় হঠাৎ "No items" message আসত-যাওয়া করত, confusing UX হতো
- Two-state (loading vs empty) properly differentiate করার জন্য

---

### 9.26) Progress Update

- [x] KUET_TradeApp.swift full explanation (function-level)
- [x] ContentView.swift full explanation (function-level)
- [x] MainTabView.swift full explanation (function-level)
- [x] AuthViewModel.swift full explanation (function-level)
- [x] AuthService.swift full explanation (function-level)
- [x] FirestoreService.swift full explanation (function-level)
- [x] StorageService.swift full explanation (function-level)
- [x] ItemViewModel.swift full explanation (function-level)
- [x] PostItemViewModel.swift full explanation (function-level)
- [ ] পরবর্তী: Utilities files overview

---

### 9.27) PostItemViewModel.swift

এই ফাইল নতুন item post এবং existing item edit করার form state control করে।

#### A) Form Fields

**@Published states:**

- `title`, `description`, `priceText`, `selectedCategory`, `selectedImages`
- `isLoading`, `errorMessage`, `showError`
- `didPostSuccessfully`, `didEditSuccessfully`
- `existingImageURLs` (edit mode-এ existing images)

**কাজ:** নতুন/edit item form-এর সব state রাখা।

---

#### B) `func loadItem(_ item: Item)`

**কাজ:** edit mode-এ existing item data form field-এ load করা।

**Input:** `item: Item` (edited item)

**Output:** direct return নেই

**ভিতরে:** `title`, `description`, `priceText`, `category` copy করা + `existingImageURLs` store করা।

---

#### C) `func addImage(_ image: UIImage)`

**কাজ:** নতুন image list-এ add করা।

**Input:** `image: UIImage`

**Output:** `selectedImages` append

**Check:** `canAddMoreImages` (max limit check, default 3)।

**Side effect:** `selectedImages` array-তে যোগ।

---

#### D) `func removeImage(at index: Int)` & `func removeExistingImage(at index: Int)`

**কাজ:** নতুন বা পুরনো image remove করা।

**Input:** `index: Int`

**Output:** direct return নেই

**ভিতরে:** bounds check করে index-এ remove করা।

**পার্থক্য:**

- `removeImage`: `selectedImages` (নতুন uploaded) থেকে
- `removeExistingImage`: `existingImageURLs` (আগে থেকে আছে) থেকে

---

#### E) `func validate() -> Bool`

**কাজ কী:** title, description, price, image সব field validate করা।

**Input:** আলাদা input নেই, form states থেকে

**Output:** `Bool` (true = valid, false = invalid)

**Check করে:**

1. title empty না এবং max length (AppConstants.maxTitleLength)
2. description empty না এবং max length
3. price valid number এবং positive
4. image count >= 1 (post mode)

**Return:** সব valid হলে `true`, else `false` + showErrorMessage।

---

#### F) `func postItem() async`

**কাজ কী:** নতুন item Firebase-এ upload করা।

**Input:** direct parameter নেই

**Output:** direct return নেই, side effect: `didPostSuccessfully`, error flags update

**ভিতরে:**

1. `validate()` call, fail হলে return
2. `isLoading = true`
3. `StorageService.uploadImages()` -> image URLs get করা
4. `Item` object create (title, desc, price, category, imageURLs, sellerID, timestamp)
5. `FirestoreService.createItem()` -> Firestore save
6. success -> `clearForm()`, `didPostSuccessfully = true`
7. failure -> `mapError()` + `showErrorMessage()`
8. শেষে `isLoading = false`

---

#### G) `func updateItem() async`

**কাজ কী:** existing item update করা।

**Input:** নেই

**Output:** direct return নেই

**ভিতরে:**

1. `validate()`
2. নতুন images থাকলে `uploadImages()` call
3. removed images থাকলে (যা `existingImageURLs`-এ ছিল কিন্তু এখন নেই) `deleteImages()` call
4. item-এর fields update: title/desc/price/category/imageURLs merge
5. `updatedAt` timestamp set
6. `FirestoreService.updateItem()` -> save
7. success -> `didEditSuccessfully = true`

---

#### H) `func clearForm()`

**কাজ কী:** form সব field reset করা।

**Input:** নেই

**Output:** নেই

**ভিতরে:** সব @Published state-কে default value:

- strings = ""
- arrays = []
- bools = false

---

#### I) Computed Properties

**`var price: Double`**

- `Double(priceText) ?? 0`
- form input থেকে parse করে

**`var canAddMoreImages: Bool`**

- `selectedImages.count < AppConstants.Validation.maxImages`

**`var titleCharCount: String`**

- `"\(title.count)/\(AppConstants.Validation.maxTitleLength)"`

**`var descCharCount: String`**

- similar, maxDescriptionLength

**`var totalImageCount: Int`**

- `selectedImages.count + existingImageURLs.count` (edit mode-এ)

---

### 9.28) Mini Data Flow (PostItemViewModel)

1. UI form input (title/desc/price/category) -> @Published state change
2. Image picker -> `addImage()`
3. User tap "Post" -> `postItem()` call
4. validation -> image upload -> item create -> success state show
5. Edit mode: `loadItem()` call -> form populate
6. Edit submit -> `updateItem()` -> image sync
7. Clear button -> `clearForm()` reset everything

---

### 9.29) Viva/Defense Ready Questions (PostItemViewModel)

1. কেন `validate()` separate method-এ রাখা হয়েছে?

**উত্তর:** Validation logic separate রাখার সুবিধা:

- **Reusable**: post এবং edit দুটো ফাংশনেই call করা যায়
- **Testable**: validation logic isolated, unit test করা সহজ
- **Single Responsibility**: validation rule আলাদা থাকে, business logic আলাদা থাকে
- **Maintainable**: শুধু validation rule বদলাতে একটা জায়গা edit করলে চলে

---

2. edit mode-এ removed image কীভাবে delete হয়?

**উত্তর:** Edit flow-এ:

- `existingImageURLs` মূলত edit-এর আগে যেসব images ছিল
- user যখন কোনো image remove করে সুইপ-দিয়ে, `removeExistingImage()` call হয়
- যে URLs এখন `existingImageURLs`-এ নেই, কিন্তু মূল item document-এ ছিল, সেগুলো delete candidates
- `updateItem()` call হলে, differences track করে যেগুলো remove হলো, সেগুলোর URLs `StorageService.deleteImages()` pass করা হয়
- Firebase Storage থেকে physically delete হয়

---

3. Multiple images upload-এর সময় কোনো fail হলে কি করে?

**উত্তর:** StorageService.uploadImages() sequential upload করে। যদি প্রথম image upload হলেও দ্বিতীয় fail হয়:

- `throws` হবে
- `postItem()`-এ catch block-এ `showErrorMessage()` দেখাবে
- `isLoading = false`
- User error message দেখে retry করতে পারে
- Trade-off: partial upload না করে সব success হওয়া পর্যন্ত সাপেক্ষে থাকা (atomic operation principle)

---

4. Async/await error handling-এ try/catch structure কী?

**উত্তর:** Pattern:

```swift
do {
    isLoading = true
    let urls = try await StorageService.uploadImages(...)
    try await FirestoreService.createItem(...)
    clearForm()
    didPostSuccessfully = true
} catch {
    let message = mapError(error)
    showErrorMessage(message)
} finally {
    isLoading = false
}
```

- `do`: async operations
- `catch`: error handling
- `finally` logic: `isLoading = false` দুটোতেই চব্বিশ (success/fail)

---

5. Image URL list update করার সময় order matter করে?

**উত্তর:** হ্যাঁ, order মেইনটেইন করা important:

- Item document-এ imageURLs একটা array, order user upload করার order-এ রাখা হয়
- First image → thumbnail হিসেবে display হয় (HomeView card-এ)
- Gallery view-তে যে order UI দেখায়, সেটা array element order-এ থাকে
- যদি upload order scramble হয়, user-এর expectation misмatch হয়
- তাই sequential upload, index-বেসড unique path, order-preserving।

---

### 9.30) Progress Update

- [x] KUET_TradeApp.swift full explanation (function-level)
- [x] ContentView.swift full explanation (function-level)
- [x] MainTabView.swift full explanation (function-level)
- [x] AuthViewModel.swift full explanation (function-level)
- [x] AuthService.swift full explanation (function-level)
- [x] FirestoreService.swift full explanation (function-level)
- [x] StorageService.swift full explanation (function-level)
- [x] ItemViewModel.swift full explanation (function-level)
- [x] PostItemViewModel.swift full explanation (function-level)
- [ ] পরবর্তী: Models (Item.swift, User.swift)

---

## 10) Models (Data Structures)

Models হলো app-এর data representation। Codable implement করে Firestore encode/decode-এর জন্য prepare।

### 10.1) Item.swift

Marketplace item-এর complete data model।

#### Properties (Key):

- `id: String` (Firestore document ID)
- `title: String` (item name, max 80 chars)
- `description: String` (details, max 500 chars)
- `price: Double` (BDT amount)
- `category: ItemCategory` (enum)
- `imageURLs: [String]` (Firebase Storage URLs, max 3)
- `sellerID: String` (seller-এর user ID)
- `sellerName: String` (caching জন্য)
- `phone: String` (seller phone)
- `isAvailable: Bool` (active true, sold false)
- `createdAt: Timestamp` (post date)
- `updatedAt: Timestamp` (last edit)

#### Enums:

**ItemCategory:**

- cases: `.books`, `.electronics`, `.clothing`, `.furniture`, `.sports`, `.other` ইত্যাদি
- `rawValue: String` (Firestore-এ store করার জন্য)

**ItemSortOption:**

- `.newest`, `.oldest`, `.priceAsc`, `.priceDesc`

#### Codable:

- Firestore-এ encode/decode হয় CodingKeys দিয়ে (Timestamp field-দের জন্য custom)

---

### 10.2) User.swift (KTUser)

একটা user-এর profile information।

#### Properties:

- `id: String` (Firebase Auth UID)
- `name: String`
- `email: String`
- `phone: String`
- `department: String` (KUET department)
- `profileImageURL: String?` (optional profile pic)
- `bio: String?` (optional short bio)
- `createdAt: Timestamp` (account creation date)
- `isVerified: Bool` (future: email verified flag)

#### Methods:

**`init(from firebaseUser:)`**

- Firebase Auth এর user থেকে KTUser minimal create করা (graceful fallback-এর জন্য)
- UID + Email extract করে, name/phone nil সহ

---

### 10.3) Data Flow (Models)

1. UI input -> ViewModel form field
2. User submit -> model object create (`Item` বা `KTUser`)
3. `Encodable` → JSON → Firestore store
4. Data fetch -> JSON → `Decodable` → model object
5. Model object -> UI binding display

---

### 10.4) Viva Questions (Models)

1. কেন `Codable` protocol implement করা দরকার?
2. `Timestamp` field custom Codable কেন লাগে?
3. Optional fields (`bio`, `profileImageURL`) কেন রাখা হয়েছে?
4. `ItemCategory` enum কেন `String: CaseIterable` conform করে?
5. `isVerified` future flag কিসের জন্য?

---

## 11) Utilities - Overview

### 11.1) Constants.swift

App-wide constants centralized।

**Key groups:**

- **App Info**: appName (`"KUET Trade"`), appTagline, universityName
- **Collections**: Firestore collection names (`"users"`, `"items"`)
- **Validation**: minPasswordLength, maxTitleLength, maxDescriptionLength, maxPrice, maxImages
- **Departments**: KUET এর departments list (Enum + rawValue array)

**কেন দরকার:** hardcoded value avoid, centralized config।

---

### 11.2) Extensions.swift

Helper methods যোগ করা standard types-এ।

**String:**

- `isValidEmail: Bool` (regex check)
- `isValidPhone: Bool` (10-14 digits pattern)
- `trimmed: String` (removes whitespace)

**View:**

- `hideKeyboard()` (dismiss keyboard)
- `cardStyle() -> some View` (reusable styling)

**Date:**

- `formattedString: String` ("Mar 28, 2026" format)

**Double:**

- `formattedAsTaka: String` ("৳1500" format)

---

### 11.3) FirestoreRules.swift

Documentary only - Firebase Security Rules reference।

**Content:**

- Users collection rules (self-managed)
- Items collection rules (authenticated can read, creator can write)
- Storage rules (image size limits)

---

### 11.4) NetworkMonitor.swift

Internet connectivity observe করা, reactive banner state।

**Key:**

- `@Published var isConnected: Bool`
- `@Published var connectionType: ConnectionType` (wifi/cellular/wired)
- `NWPathMonitor` use করে system-level network status track করে
- `OfflineBannerView`: গুলো red banner offline হলে

---

## 12) Views - High-Level Overview

সব Views UI render করে। ViewModels থেকে state observe করে display।

### 12.1) Auth Views

- **LoginView**: email/password form, forgot password link
- **SignUpView**: name, email, phone, department, password form
- **ForgotPasswordView**: password reset, email sent confirmation

### 12.2) Home/Browsing

- **HomeView**: item grid, search bar, filter sheet, pull-to-refresh
- **ItemCardView**: item preview (image, title, price, seller)
- **ItemDetailView**: full item page, gallery, seller info, contact buttons

### 12.3) Posting/Editing

- **PostItemView**: form to create new listing
- **EditItemView**: form to modify existing listing

### 12.4) User Profile

- **ProfileView**: user info, app share, sign out
- **MyAdsView**: my listings, edit/delete actions

### 12.5) Components (Reusable)

- **LaunchScreenView**: animated splash screen
- **ImagePicker**: camera/photo library integration
- **ContactSellerButton**: call/whatsapp/sms actions
- **ShimmerView**: skeleton loading placeholder
- **OfflineBannerView**: no internet indicator

---

### 12.6) Views Summary

**Total: ~14 files**

- 3 auth screens
- 3 home/browse screens
- 2 post/edit screens
- 2 profile screens
- 1 search/filter screen
- 4 reusable components

প্রতিটা view SwiftUI এবং reactive patterns follow করে।

---

## Summary: Project Structure Recap

### Architecture Pattern: **MVVM + Service Layer**

- **Models**: Data structure (Item, KTUser)
- **Services**: Firebase backend (Auth, Firestore, Storage)
- **ViewModels**: State + business logic (AuthVM, ItemVM, PostItemVM)
- **Views**: UI rendering + user interaction
- **Utilities**: Constants, extensions, network monitoring

### Key Technologies:

- **SwiftUI**: UI framework
- **Firebase**: Backend (Auth, Firestore DB, Cloud Storage)
- **async/await**: Asynchronous operations
- **@Published/@ObservedObject**: Reactive state management
- **URLSession Codable**: Networking + JSON serialization

### File Breakdown:

| Category   | Files | Purpose                        |
| ---------- | ----- | ------------------------------ |
| Root       | 2     | App entry, auth gate           |
| Models     | 2     | Data structures                |
| Services   | 3     | Firebase operations            |
| ViewModels | 3     | State management               |
| Views      | 14+   | UI screens                     |
| Utilities  | 4     | Constants, helpers, monitoring |

**Total: 28+ Swift files**

---

## Defense/Interview Tips

### Technical Topics to Master:

1. **Architecture**: Why MVVM? (Separation of concerns, testability)
2. **State Management**: @Published, @StateObject, @ObservedObject differences
3. **Firebase**: Auth flow, Firestore queries, Storage image handling
4. **Async Patterns**: async/await, error handling, cancellation
5. **SwiftUI**: View lifecycle, modifiers, bindings
6. **Security**: User data protection, Firebase rules

### Common Questions:

- "Walk us through the login flow"
- "How does image upload work?"
- "What happens when network disconnects?"
- "How do you handle concurrent requests?"
- "Explain your error handling strategy"
- "What would you improve in production?"

### Demo Scenarios:

1. Create new listing with images
2. Search + filter items
3. Edit existing listing
4. Handle offline scenario
5. Profile management

---

## Final Notes

এই project শুরু-থেকে-শেষ পর্যন্ত iOS marketplace app বানানো শিখায়। Real-world patterns ব্যবহার করে এবং production-ready architecture maintain করে implement করা হয়েছে।

**Next Level Improvements:**

- Paginated queries (infinite scroll)
- Cloud functions (auto-cleanup, notifications)
- Advanced search (Elasticsearch integration)
- User ratings/reviews system
- Payment integration
- Real-time chat messaging

---

---

## 13) Complete User Journey Flows (Code-Level Tracing)

এখানে প্রতিটি major flow trace করা হয়েছে - কোন ভিউ থেকে শুরু, কোন ফাংশন call হয়, কোন পরামিতি pass হয়, কোন service call হয়, এবং কী update হয়।

---

## **FLOW 1: App Launch - Firebase Setup থেকে শুরু করে Auth Checking পর্যন্ত**

### ↓ Step-by-Step Execution:

**Step 1️⃣: App শুরু হয় → AppDelegate Firebase configure**

```
File: KUET_TradeApp.swift
Line: 11-14

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [...]) -> Bool {
        FirebaseApp.configure()  // ← LINE 14: Firebase initialization
        return true
    }
}
```

**কী হয়:**

- iOS app lifecycle-এর `didFinishLaunchingWithOptions` automatically called
- `FirebaseApp.configure()` call → GoogleService-Info.plist থেকে Firebase config read
- Auth/Firestore/Storage এখন ready

**Continue:**

**Step 2️⃣: App Scene render → ContentView() load হয়**

```
File: KUET_TradeApp.swift
Line: 19-22

@main
struct KUET_TradeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()  // ← LINE 22: First UI rendered
        }
    }
}
```

**কী হয়:**

- `@main` attribute মানে এটা app entry point
- iOS এই struct থেকে app scene তৈরি করে
- `ContentView()` render হয় (root UI)

**Continue:**

**Step 3️⃣: ContentView load → AuthViewModel create + listener start**

```
File: ContentView.swift
Line: 11-12

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    // ← LINE 12: AuthViewModel initialization starts
```

**কী হয়:**

- `@StateObject` annotation → SwiftUI `AuthViewModel` initialize করে
- ContentView lifecycle = AuthViewModel lifecycle (same)
- `authViewModel.init()` call হয়

**Continue:**

**Step 4️⃣: AuthViewModel init → Firebase auth listener register করে**

```
File: AuthViewModel.swift
Line: 46-53

init() {
    listenToAuthState()  // ← LINE 48: Start listening to Firebase auth state
}

private func listenToAuthState() {
    authListenerHandle = AuthService.shared.addAuthStateListener { [weak self] loggedIn in
        // ← LINE 55: Firebase listener registered
```

**কী হয়:**

- `AuthService.shared.addAuthStateListener()` call
- Firebase এর auth state listener নতুন করে register হয়
- যখন auth state change হয়, closure execute হবে

**Continue:**

**Step 5️⃣: Firebase listener callback → Auth checking শুরু**

```
File: AuthViewModel.swift
Line: 55-65

authListenerHandle = AuthService.shared.addAuthStateListener { [weak self] loggedIn in
    Task { @MainActor in
        self?.isLoggedIn = loggedIn          // ← User logged in?
        self?.isCheckingAuth = false         // ← Auth checking complete

        if loggedIn {
            await self?.fetchUser()          // ← If logged in, fetch profile
        } else {
            self?.currentUser = nil          // ← If logged out, clear user
        }
    }
}
```

**কী হয়:**

- Firebase current user exist check
- `isLoggedIn: Bool` update (true/false)
- `isCheckingAuth = false` → checking phase complete

**Continue:**

**Step 6️⃣: ContentView body re-render → Auth state অনুযায়ী UI switch**

```
File: ContentView.swift
Line: 15-23

var body: some View {
    Group {
        if authViewModel.isCheckingAuth {
            LaunchScreenView()           // ← Step 6a: Checking phase → Launch animation
        } else if authViewModel.isLoggedIn {
            MainTabView(authViewModel: authViewModel)  // ← Step 6b: Logged in → Main app
        } else {
            LoginView(viewModel: authViewModel)  // ← Step 6c: Logged out → Login form
        }
    }
}
```

**Context:**

- `isCheckingAuth == true` থাকলে → Launch screen দেখায় (first 0.5-3 seconds)
- Firebase response আসলে `isCheckingAuth = false` হয়
- তারপর `isLoggedIn` value অনুযায়ী MainTabView বা LoginView দেখায়

**Animation দ্রুত হয়:**

- `.animation(.easeInOut(duration: 0.4), value: authViewModel.isLoggedIn)` (Line 26)
- `.animation(.easeInOut(duration: 0.4), value: authViewModel.isCheckingAuth)` (Line 27)

---

### 📊 FLOW 1 Summary:

| Step | File                     | Function                      | Action                                    |
| ---- | ------------------------ | ----------------------------- | ----------------------------------------- |
| 1    | KUET_TradeApp            | didFinishLaunchingWithOptions | FirebaseApp.configure()                   |
| 2    | KUET_TradeApp            | body scene                    | ContentView() render                      |
| 3    | ContentView              | init                          | @StateObject AuthViewModel create         |
| 4    | AuthViewModel            | init                          | listenToAuthState() call                  |
| 5    | AuthService              | addAuthStateListener          | Firebase listener register                |
| 6    | AuthViewModel (listener) | callback                      | isCheckingAuth/isLoggedIn update          |
| 7    | ContentView              | body                          | Conditional render (Launch/MainTab/Login) |

---

## **FLOW 2: Login Flow - User email/password দিয়ে লগইন**

### ↓ Step-by-Step Execution:

**User action: LoginView-এ email/password enter করে "Log In" button tap**

**Step 1️⃣: LoginView → Login button tap → viewModel.login() call**

```
File: LoginView.swift
Line: 67-72

Button {
    Task {
        await viewModel.login()  // ← LINE 71: AuthViewModel.login() called
    }
} label: {
    HStack(spacing: 8) {
        if viewModel.isLoading {
            ProgressView()
                .tint(.white)
        }
        Text("Log In")
    }
}
```

**কী হয়:**

- User button tap → Task async block start
- `AuthViewModel.login()` async function `await` করে

**Continue:**

**Step 2️⃣: AuthViewModel.login() → validation check**

```
File: AuthViewModel.swift
Line: 114-120

func login() async {
    // Step 2a: Validate
    guard validateLoginFields() else { return }  // ← LINE 117: Validation

    isLoading = true  // ← LINE 119: Show loading state
    do {
        // ... (next steps)
```

**কী হয়:**

- `validateLoginFields()` check:
  - `loginEmail` empty না?
  - `loginPassword` empty না?
  - Email valid format?
  - Password min length?
- Validation fail → error message show + return
- Validation success → continue

**Continue:**

**Step 3️⃣: AuthService.signIn() call → Firebase Auth sign in**

```
File: AuthViewModel.swift
Line: 121-125

try await AuthService.shared.signIn(
    email: loginEmail.trimmed,     // ← Trimmed input
    password: loginPassword
)
clearLoginFields()  // ← Clear input after success
```

**কী হয়:**

- Control → `AuthService.shared.signIn()` async function
- Firebase email/password verify

**Jump to AuthService.signIn():**

```
File: AuthService.swift
Line: 51-52

func signIn(email: String, password: String) async throws {
    try await auth.signIn(withEmail: email, password: password)  // ← Firebase auth.signIn()
}
```

**কী হয়:**

- Firebase SDK `auth.signIn(withEmail:password:)` direct call
- Firebase backend এ validation
- Success → Firebase internally currentUser set করে
- Failure → throws error

**Continue:**

**Step 4️⃣: Firebase auth state change listener trigger হয়**

আগে auth listener register করা ছিল (FLOW 1, Step 5)। এখন Firebase auth state changed, তাই listener callback automatic execute:

```
File: AuthViewModel.swift
Line: 55-65

authListenerHandle = AuthService.shared.addAuthStateListener { [weak self] loggedIn in
    Task { @MainActor in
        self?.isLoggedIn = true              // ← Now true (user logged in)
        self?.isCheckingAuth = false

        if true {  // loggedIn == true
            await self?.fetchUser()          // ← Step 4b: Fetch user profile
        }
    }
}
```

**কী হয়:**

- `loggedIn = true` (Firebase এ এখন user আছে)
- `isLoggedIn = true` → @Published, সব observers notify
- Profile fetch trigger হয়

**Continue:**

**Step 5️⃣: fetchUser() → Firestore থেকে user document fetch**

```
File: AuthViewModel.swift
Line: 95-113

func fetchUser() async {
    do {
        currentUser = try await AuthService.shared.fetchCurrentUser()
        // ← LINE 97: Fetch from Firestore "users" collection
    } catch {
        // Fallback: যদি Firestore fail হয়
        if let firebaseUser = Auth.auth().currentUser {
            currentUser = KTUser(
                uid: firebaseUser.uid,
                name: firebaseUser.displayName ?? ...,
                ...
            )
        }
    }
}
```

**Jump to AuthService.fetchCurrentUser():**

```
File: AuthService.swift
Line: 68-71

func fetchCurrentUser() async throws -> KTUser? {
    guard let uid = currentUserID else { return nil }
    let snapshot = try await db.collection("users").document(uid).getDocument()
    // ← LINE 70: Firestore query: fetch "users/{uid}"
    return try snapshot.data(as: KTUser.self)  // ← LINE 71: Decode to KTUser
}
```

**কী হয়:**

- Firestore `users` collection থেকে current user document fetch
- Document → `KTUser` Codable decode
- `currentUser` set হয় (@Published)

**Continue:**

**Step 6️⃣: ContentView observe করে → isLoggedIn change detect → MainTabView render**

```
File: ContentView.swift
Line: 15-23

var body: some View {
    Group {
        if authViewModel.isCheckingAuth {
            LaunchScreenView()
        } else if authViewModel.isLoggedIn {
            MainTabView(authViewModel: authViewModel)  // ← Now rendered (was LoginView before)
        } else {
            LoginView(viewModel: authViewModel)
        }
    }
    .animation(.easeInOut(duration: 0.4), value: authViewModel.isLoggedIn)
    // ← Animation triggers when isLoggedIn changes
}
```

**কী হয়:**

- `@ObservedObject` → `authViewModel.isLoggedIn` change observe
- body re-render
- condition `isLoggedIn == true` → MainTabView render
- Animation smooth transition

---

### 📊 FLOW 2 Summary:

| Step | File          | Function           | Action                                    |
| ---- | ------------- | ------------------ | ----------------------------------------- |
| 1    | LoginView     | button action      | Task { await viewModel.login() }          |
| 2    | AuthViewModel | login()            | validateLoginFields() + set isLoading     |
| 3    | AuthViewModel | login()            | AuthService.shared.signIn()               |
| 4    | AuthService   | signIn()           | Firebase auth.signIn(withEmail:password:) |
| 5    | Firebase      | (internal)         | Verify credentials, set currentUser       |
| 6    | AuthViewModel | listener callback  | isLoggedIn = true                         |
| 7    | AuthViewModel | login (catch)      | clearLoginFields()                        |
| 8    | AuthViewModel | listener           | if loggedIn → fetchUser()                 |
| 9    | AuthService   | fetchCurrentUser() | Firestore users/{uid} fetch + decode      |
| 10   | AuthViewModel | fetchUser()        | currentUser = decoded KTUser              |
| 11   | ContentView   | body observer      | isLoggedIn change → MainTabView render    |

---

## **FLOW 3: Sign Up - নতুন Account তৈরি করা**

### ↓ Step-by-Step Execution:

**User action: SignUpView-এ ফর্ম ভরে "Create Account" button tap**

**Step 1️⃣: SignUpView → Sign Up button tap → viewModel.signUp() call**

```swift
File: SignUpView.swift
Line: 140-145

Button {
    Task {
        await viewModel.signUp()  // ← LINE 143: AuthViewModel.signUp() called
    }
} label: {
    HStack(spacing: 8) {
        if viewModel.isLoading {
            ProgressView()
```

**কী হয়:**

- User সব ফিল্ড fill করে button tap করে
- `Task { await viewModel.signUp() }` async block execute

**Continue:**

**Step 2️⃣: AuthViewModel.signUp() → Validation**

```swift
File: AuthViewModel.swift
Line: 128-138

func signUp() async {
    // Step 2a: Validate
    guard validateSignupFields() else { return }  // ← LINE 131: All fields validate

    isLoading = true  // ← LINE 133: Show loading
    do {
        let user = try await AuthService.shared.signUp(  // ← LINE 135: Call service
            name: signupName.trimmed,
            email: signupEmail.trimmed,
            phone: signupPhone.trimmed,
            department: signupDepartment,
            password: signupPassword
        )
        currentUser = user  // ← LINE 141: Success
        clearSignupFields()  // ← LINE 142: Clear form
```

**Validation checks (validateSignupFields):**

- Name, email, phone, department, password সব non-empty
- Email valid format
- Phone 10-14 digits
- Password >= 6 characters
- Password == Confirm password

**Continue:**

**Step 3️⃣: AuthService.signUp() → Firebase Auth + Firestore**

```swift
File: AuthService.swift
Line: 27-43

func signUp(name: String, email: String, phone: String, department: String, password: String) async throws -> KTUser {
    let result = try await auth.createUser(withEmail: email, password: password)
    // ← LINE 29: Firebase createUser

    let uid = result.user.uid

    // Save display name to Firebase Auth profile
    let changeRequest = result.user.createProfileChangeRequest()
    changeRequest.displayName = name
    try await changeRequest.commitChanges()  // ← LINE 36: Auth profile update

    // Create KTUser object
    let newUser = KTUser(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        department: department,
        joinedDate: Date()
    )

    try db.collection("users").document(uid).setData(from: newUser)
    // ← LINE 45: Save to Firestore "users" collection

    return newUser  // ← LINE 46: Return created user
}
```

**কী হয়:**

- **Step 3a**: `auth.createUser(withEmail:password:)` → Firebase Auth-এ नया account create
- **Step 3b**: `createProfileChangeRequest().displayName = name` → Auth profile update
- **Step 3c**: `db.collection("users").document(uid).setData(from: newUser)` → Firestore users document create

**Continue:**

**Step 4️⃣: Firebase creates account → Auth state change listener trigger**

```swift
File: AuthViewModel.swift
Line: 55-65

authListenerHandle = AuthService.shared.addAuthStateListener { [weak self] loggedIn in
    Task { @MainActor in
        self?.isLoggedIn = true              // ← Now true (new account exists)
        self?.fetchUser()                    // ← Fetch from Firestore
    }
}
```

**Continue:**

**Step 5️⃣: fetchUser() → Get user from Firestore**

(Same as FLOW 2, Step 5)

**Continue:**

**Step 6️⃣: SignUpView → Success state show**

```swift
File: SignUpView.swift
Line: 180-200 (approx)

if viewModel.didPostSuccessfully {  // didPostSuccessfully automatically set after signUp success
    postSuccessView  // Success feedback
} else {
    signupFormView
}
```

---

### 📊 FLOW 3 Summary:

| Step | File          | Function            | Action                                         |
| ---- | ------------- | ------------------- | ---------------------------------------------- |
| 1    | SignUpView    | button action       | Task { await viewModel.signUp() }              |
| 2    | AuthViewModel | signUp()            | validateSignupFields() + set isLoading         |
| 3    | AuthViewModel | signUp()            | AuthService.shared.signUp()                    |
| 4    | AuthService   | signUp()            | auth.createUser(withEmail:password:)           |
| 5    | AuthService   | signUp()            | createProfileChangeRequest() + commitChanges() |
| 6    | AuthService   | signUp()            | Firestore setData to users/{uid}               |
| 7    | Firebase      | (internal)          | Create new Auth user + set currentUser         |
| 8    | AuthViewModel | listener callback   | isLoggedIn = true + fetchUser()                |
| 9    | AuthService   | fetchCurrentUser()  | Firestore users/{uid} fetch                    |
| 10   | AuthViewModel | fetchUser()         | currentUser = new KTUser                       |
| 11   | SignUpView    | didPostSuccessfully | Show success state                             |

---

## **FLOW 4: Browse Items - Home থেকে Items দেখা + Filter করা**

### ↓ Step-by-Step Execution:

**User action: MainTabView-এ Home tab open হয়**

**Step 1️⃣: MainTabView render → HomeView initialize**

```swift
File: MainTabView.swift
Line: 13-19

TabView(selection: $selectedTab) {
    HomeView(itemViewModel: itemViewModel)  // ← LINE 17: HomeView render + itemViewModel pass
        .tabItem {
            Label("Home", systemImage: "house.fill")
        }
        .tag(0)
```

**Continue:**

**Step 2️⃣: MainTabView init → ItemViewModel create + loadItems()**

```swift
File: MainTabView.swift
Line: 5

@StateObject private var itemViewModel = ItemViewModel()  // ← init called
```

**Jump to ItemViewModel.init():**

```swift
File: ItemViewModel.swift
Line: 41-44

init() {
    Task {
        await loadItems()  // ← LINE 43: Auto-load items on init
    }
}
```

**Continue:**

**Step 3️⃣: ItemViewModel.loadItems() → Firestore fetch all items**

```swift
File: ItemViewModel.swift
Line: 46-57

func loadItems() async {
    isLoading = allItems.isEmpty  // ← Show skeleton if first load
    do {
        let items = try await FirestoreService.shared.fetchAllItems()
        // ← LINE 50: Firestore query all items

        allItems = items  // ← LINE 51: Store all items
        applyFilters()    // ← LINE 52: Apply current filters
    } catch {
        errorMessage = "Failed to load items: ..."
        showError = true
    }
    isLoading = false
    isRefreshing = false  // ← LINE 57: Stop loading state
}
```

**Jump to FirestoreService.fetchAllItems():**

```swift
File: FirestoreService.swift (referenced in code)

func fetchAllItems() async throws -> [Item] {
    let snapshot = try await db.collection("items").whereField("isAvailable", isEqualTo: true).getDocuments()
    // ← Query all available items

    let items = snapshot.documents.compactMap { doc in
        try? doc.data(as: Item.self)
    }
    // ← Decode each doc to Item model

    return items.sorted { $0.createdAt > $1.createdAt }
    // ← Sort by newest first
}
```

**Continue:**

**Step 4️⃣: HomeView render → Items grid display**

```swift
File: HomeView.swift
Line: 45-70 (approx)

ScrollView {
    VStack(spacing: 16) {
        // Search bar
        HStack {
            TextField("Search items...", text: $itemViewModel.searchText)
            // ← LINE ~50: Search text binding (triggers applyFilters via didSet)
        }

        // Active filter tags
        if itemViewModel.hasActiveFilters {
            // Show active filters
        }

        // Items grid
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(itemViewModel.filteredItems) { item in
                ItemCardView(item: item)  // ← Display each item card
            }
        }
    }
}
```

**Continue:**

**Step 5️⃣: User searches "Books" → searchText updated → applyFilters() trigger**

```swift
File: ItemViewModel.swift
Line: 13-15

@Published var searchText: String = "" {
    didSet { applyFilters() }  // ← LINE 15: Automatic filter apply on change
}
```

**Jump to applyFilters():**

```swift
File: ItemViewModel.swift
Line: 59-93

func applyFilters() {
    var result = allItems

    // Search filter
    if !searchText.trimmed.isEmpty {
        let query = searchText.trimmed.lowercased()
        result = result.filter { item in
            item.title.lowercased().contains(query) ||
            item.description.lowercased().contains(query) ||
            item.sellerName.lowercased().contains(query) ||
            item.category.rawValue.lowercased().contains(query)
        }
    }

    // Category, price, sort filters...

    filteredItems = result  // ← LINE 93: Update UI
}
```

**Continue:**

**Step 6️⃣: User tap category filter → selectedCategory updated → applyFilters()**

```swift
File: ItemViewModel.swift
Line: 17-19

@Published var selectedCategory: ItemCategory? = nil {
    didSet { applyFilters() }  // ← Auto-filter on category change
}
```

**Continue:**

**Step 7️⃣: HomeView observe filteredItems → Items grid re-render**

```swift
File: HomeView.swift

@ObservedObject var itemViewModel: ItemViewModel
// ← Observe itemViewModel.filteredItems changes

// In body:
LazyVGrid(columns: columns, spacing: 12) {
    ForEach(itemViewModel.filteredItems) { item in  // ← Observe this
        ItemCardView(item: item)
    }
}
```

**কী হয়:**

- `filteredItems` update → HomeView body re-render
- GridView পুনরায় items দিয়ে populate হয়

---

### 📊 FLOW 4 Summary:

| Step | File             | Function        | Action                                        |
| ---- | ---------------- | --------------- | --------------------------------------------- |
| 1    | MainTabView      | body            | HomeView(itemViewModel: itemViewModel) render |
| 2    | MainTabView      | init            | @StateObject ItemViewModel() create           |
| 3    | ItemViewModel    | init            | Task { await loadItems() }                    |
| 4    | ItemViewModel    | loadItems()     | FirestoreService.shared.fetchAllItems()       |
| 5    | FirestoreService | fetchAllItems() | Firestore query + decode to [Item]            |
| 6    | ItemViewModel    | loadItems()     | allItems = items + applyFilters()             |
| 7    | HomeView         | body            | @ObservedObject itemViewModel watch           |
| 8    | User/UI          | input           | Change searchText / selectedCategory          |
| 9    | ItemViewModel    | didSet          | applyFilters() automatic call                 |
| 10   | ItemViewModel    | applyFilters()  | Filter + sort `allItems` → `filteredItems`    |
| 11   | HomeView         | body observer   | filteredItems change → LazyVGrid re-render    |

---

## **FLOW 5: Post New Item - Listing তৈরি করা**

### ↓ Step-by-Step Execution:

**User action: MainTabView-এ Post tab tap**

**Step 1️⃣: MainTabView → PostItemView initialize**

```swift
File: MainTabView.swift
Line: 20-25

PostItemView(itemViewModel: itemViewModel)  // ← LINE 21: PostItemView render
    .tabItem {
        Label("Post", systemImage: "plus.circle.fill")
    }
    .tag(1)
```

**Continue:**

**Step 2️⃣: PostItemView load → PostItemViewModel create**

```swift
File: PostItemView.swift
Line: 12

@StateObject private var viewModel = PostItemViewModel()  // ← Create
```

**Continue:**

**Step 3️⃣: User fills form → title, description, price, category, images**

```swift
File: PostItemView.swift
Line: 60-90 (approx)

TextField("e.g. Data Structures Textbook", text: $viewModel.title)
// ← Form bindings

SecureField(..., text: $viewModel.description)
TextField(..., text: $viewModel.priceText)
// ← All fields bind to @Published viewModel properties
```

**Continue:**

**Step 4️⃣: User adds images → ImagePicker → viewModel.addImage()**

```swift
File: PostItemView.swift
Line: 23-31

.sheet(isPresented: $viewModel.showPhotoLibrary) {
    ImagePicker(image: $viewModel.pickedImage, sourceType: .photoLibrary)
}
.fullScreenCover(isPresented: $viewModel.showCamera) {
    ImagePicker(image: $viewModel.pickedImage, sourceType: .camera)
}
```

**Jump to ImagePicker.swift (logic):**

```swift
When user selects image:
    $viewModel.pickedImage = selectedUIImage

Then PostItemView observes pickedImage change:
     image picker dismiss
     viewModel.addImage(pickedImage)
```

**Jump to PostItemViewModel.addImage():**

```swift
File: PostItemViewModel.swift (referenced)

func addImage(_ image: UIImage) {
    guard canAddMoreImages else { return }  // ← Max 3 check
    selectedImages.append(image)           // ← Add to array
}
```

**Continue:**

**Step 5️⃣: User tap "Post Ad" button → viewModel.postItem()**

```swift
File: PostItemView.swift
Line: 165-170 (approx)

Button {
    Task {
        await viewModel.postItem()  // ← LINE ~167
    }
} label: {
    Text("Post Ad")
}
```

**Jump to PostItemViewModel.postItem():**

```swift
File: PostItemViewModel.swift (referenced)
Line: ~95-120 (approx)

func postItem() async {
    // Step 5a: Validate
    guard validate() else { return }

    isLoading = true
    do {
        // Step 5b: Upload images
        let imageURLs = try await StorageService.shared.uploadImages(
            selectedImages,
            folderPath: "item_images"
        )
        // ← Images upload to Firebase Storage

        // Step 5c: Create Item object
        let item = Item(
            id: UUID().uuidString,
            title: title,
            description: description,
            price: price,
            category: selectedCategory,
            imageURLs: imageURLs,  // ← URLs from upload
            sellerID: AuthService.shared.currentUserID ?? "",
            sellerName: ... currentUser.name,
            phone: currentUser.phone,
            isAvailable: true,
            createdAt: Timestamp(),
            updatedAt: Timestamp()
        )

        // Step 5d: Save to Firestore
        _ = try await FirestoreService.shared.createItem(item)
        // ← Firestore items collection

        // Step 5e: Success
        clearForm()
        didPostSuccessfully = true  // ← Show success UI
    } catch {
        showErrorMessage(mapError(error))
    }
    isLoading = false
}
```

**Breaking down the sub-steps:**

**Step 5b: StorageService.uploadImages()**

```swift
File: Services/StorageService.swift (referenced)

func uploadImages(_ images: [UIImage], folderPath: String) async throws -> [String] {
    var urls: [String] = []

    for (index, image) in images.enumerated() {
        let fileName = "image_\(index)_\(UUID().uuidString).jpg"
        let path = "\(folderPath)/\(fileName)"

        let url = try await uploadImage(image, path: path)
        // ← Upload each individually

        urls.append(url)  // ← Collect URLs
    }

    return urls  // ← [URL1, URL2, URL3]
}
```

**Upload flow for single image:**

- Compress UIImage to JPG data (0.5 quality)
- Firebase Storage reference create
- putDataAsync() upload
- downloadURL() retrieve

**Step 5d: FirestoreService.createItem()**

```swift
File: Services/FirestoreService.swift (referenced)

func createItem(_ item: Item) async throws -> String {
    let docRef = try db.collection("items").addDocument(from: item)
    return docRef.documentID
}
```

**কী হয়:**

- `db.collection("items").addDocument(from: item)`
- auto encode + save
- Firestore auto-generates documentID

**Continue:**

**Step 6️⃣: Firestore save success → itemViewModel.loadItems() refresh**

```swift
After postItem() success:

Option 1 (Manual refresh):
    Not explicitly called in demo, but can be:
    await itemViewModel.loadItems()

Option 2 (Auto-refresh):
    Real-time listener on Firestore items collection
    (Can be added for live updates)
```

**Continue:**

**Step 7️⃣: PostItemView success state show**

```swift
File: PostItemView.swift
Line: 14-20

Group {
    if viewModel.didPostSuccessfully {
        postSuccessView  // ← Show success message
    } else {
        postFormView     // ← Show form
    }
}
```

---

### 📊 FLOW 5 Summary:

| Step | File              | Function       | Action                                           |
| ---- | ----------------- | -------------- | ------------------------------------------------ |
| 1    | MainTabView       | body           | PostItemView(itemViewModel) render               |
| 2    | PostItemView      | init           | @StateObject PostItemViewModel() create          |
| 3    | PostItemView      | user input     | title, desc, price, category bindings            |
| 4    | User/UI           | action         | Add images via ImagePicker                       |
| 5    | PostItemView      | button tap     | Task { await viewModel.postItem() }              |
| 6    | PostItemViewModel | postItem()     | validate() check                                 |
| 7    | PostItemViewModel | postItem()     | StorageService.uploadImages()                    |
| 8    | StorageService    | uploadImages() | Each image compress + upload to Firebase Storage |
| 9    | StorageService    | uploadImage()  | Download URL retrieve                            |
| 10   | StorageService    | uploadImages() | Return [URL1, URL2, URL3]                        |
| 11   | PostItemViewModel | postItem()     | Create Item object with imageURLs                |
| 12   | PostItemViewModel | postItem()     | FirestoreService.createItem()                    |
| 13   | FirestoreService  | createItem()   | db.collection("items").addDocument(from:)        |
| 14   | PostItemViewModel | success        | clearForm() + didPostSuccessfully = true         |
| 15   | PostItemView      | observer       | didPostSuccessfully change → postSuccessView     |

---

## **FLOW 6: Contact Seller - Phone, WhatsApp, বা SMS দিয়ে যোগাযোগ করা**

### ↓ Step-by-Step Execution:

**User action: ItemDetailView-এ "Call Seller" বা "WhatsApp" button tap**

**Step 1️⃣: ItemDetailView render → Contact buttons display**

```swift
File: ItemDetailView.swift (referenced)

VStack {
    ItemDetailContent(item: item)

    // Contact seller buttons
    ContactSellerButtons(phone: item.sellerPhone, itemTitle: item.title)
    // ← LINE ~X: ContactSellerButtons component
}
```

**Continue:**

**Step 2️⃣: Contact Seller button tap → performAction() execute**

```swift
File: ContactSellerButton.swift
Line: 143-151

Button {
    performAction()  // ← LINE 145: Button tap → performAction() call
} label: {
    // Button UI
}
```

**Jump to performAction():**

```swift
File: ContactSellerButton.swift
Line: 153-165

private func performAction() {
    let cleaned = cleanedPhone  // Remove spaces/dashes

    switch method {
    case .call:
        openCall(phone: cleaned)       // ← LINE 158
    case .whatsApp:
        openWhatsApp(phone: cleaned)   // ← LINE 160
    case .sms:
        openSMS(phone: cleaned)        // ← LINE 162
    }
}
```

**Continue:**

**Step 3️⃣: User selected "Call" → openCall() → URL scheme**

```swift
File: ContactSellerButton.swift
Line: 175-183

private func openCall(phone: String) {
    if let url = URL(string: "tel://\(phone)") {  // ← LINE 176: tel:// URL scheme
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)        // ← LINE 178: Open Phone app
        } else {
            showUnavailableAlert = true
        }
    }
}
```

**কী হয়:**

- `URL(string: "tel://\(phone)")` create করে tel:// scheme
- `UIApplication.shared.open(url)` iOS-এ Phone app করে dial করায়
- User Phone app-এ navigate করে

**Continue:**

**Step 3b️⃣: User selected "WhatsApp" → openWhatsApp()**

```swift
File: ContactSellerButton.swift
Line: 185-192

private func openWhatsApp(phone: String) {
    let intlPhone = internationalPhone(phone)      // ← Convert to +88XXXXXXXXXX
    let message = "Hi! I'm interested in your listing: \"\(itemTitle)\" on KUET Trade."
    let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

    if let url = URL(string: "https://wa.me/\(intlPhone)?text=\(encoded)") {
        // ← LINE 190: WhatsApp URL scheme with message
        UIApplication.shared.open(url)  // ← Open WhatsApp
    }
}
```

**কী হয়:**

- Phone number convert করে international format (+88...)
- Message URL-encode করে
- `https://wa.me/\(phone)?text=\(message)` URL open করে
- WhatsApp app open হয় বা web version

**Continue:**

**Step 3c️⃣: User selected "SMS" → openSMS()**

```swift
File: ContactSellerButton.swift
Line: 194-203

private func openSMS(phone: String) {
    let message = "Hi! I'm interested in your listing: \"\(itemTitle)\" on KUET Trade."
    let encoded = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

    if let url = URL(string: "sms:\(phone)&body=\(encoded)") {
        // ← LINE 198: SMS URL scheme with pre-filled body
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)  // ← Open SMS app
        } else {
            showUnavailableAlert = true
        }
    }
}
```

**কী হয়:**

- `sms:\(phone)&body=\(message)` URL create করে
- iOS Messages app open হয়
- তালিম বার্তা pre-filled থাকে

---

### 📊 FLOW 6 Summary:

| Step         | File                 | Function        | Action                                |
| ------------ | -------------------- | --------------- | ------------------------------------- |
| 1            | ItemDetailView       | body            | ContactSellerButtons render           |
| 2            | ContactSellerButtons | body            | Button for Call/WhatsApp/SMS create   |
| 3            | ContactSellerButton  | button action   | performAction() call                  |
| 4            | ContactSellerButton  | performAction() | Switch on ContactMethod type          |
| 5 (Call)     | ContactSellerButton  | openCall()      | URL(string: "tel://...") create       |
| 6 (Call)     | ContactSellerButton  | openCall()      | UIApplication.shared.open(url)        |
| 5 (WhatsApp) | ContactSellerButton  | openWhatsApp()  | Phone to +88 format convert           |
| 6 (WhatsApp) | ContactSellerButton  | openWhatsApp()  | Message URL-encode + wa.me URL create |
| 7 (WhatsApp) | ContactSellerButton  | openWhatsApp()  | UIApplication.shared.open(url)        |
| 5 (SMS)      | ContactSellerButton  | openSMS()       | sms://phone&body=message URL create   |
| 6 (SMS)      | ContactSellerButton  | openSMS()       | UIApplication.shared.open(url)        |

---

## **FLOW 7: Edit Item - বিদ্যমান Listing আপডেট করা**

### ↓ Step-by-Step Execution:

**User action: MyAdsView-এ "Edit" button tap**

**Step 1️⃣: MyAdsView → Edit button tap → NavigationLink**

```swift
File: MyAdsView.swift
Line: 145-158 (approx)

Button {
    // Edit action
} label: {
    Label("Edit", systemImage: "pencil")
}
.sheet(isPresented: $showEditSheet) {
    NavigationStack {
        EditItemView(item: selectedItem, onUpdate: loadMyItems)
        // ← LINE ~151: EditItemView open with selected item
    }
}
```

**Continue:**

**Step 2️⃣: EditItemView load → PostItemViewModel create**

```swift
File: EditItemView.swift
Line: 12-16

struct EditItemView: View {
    @StateObject private var viewModel = PostItemViewModel()
    @Environment(\.dismiss) private var dismiss
    let item: Item  // ← Item passed from MyAdsView
    var onUpdate: (() -> Void)? = nil
```

**Continue:**

**Step 3️⃣: EditItemView.onAppear → Pre-fill form with existing data**

```swift
File: EditItemView.swift (referenced - onAppear setup)

.onAppear {
    viewModel.loadExistingItem(item)  // ← Load item details into form

    // Pre-fill:
    viewModel.title = item.title
    viewModel.description = item.description
    viewModel.priceText = String(item.price)
    viewModel.selectedCategory = item.category
    viewModel.existingImageURLs = item.imageURLs
}
```

**Continue:**

**Step 4️⃣: User edits form → Update button tap**

```swift
File: EditItemView.swift
Line: 226-244

Button {
    Task {
        await viewModel.updateItem()  // ← LINE 229: updateItem() call
    }
} label: {
    HStack(spacing: 8) {
        if viewModel.isLoading {
            ProgressView()
                .tint(.white)
        }
        Text("Update Item")
            .fontWeight(.semibold)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.accentColor)
    .foregroundStyle(.white)
    .cornerRadius(12)
}
```

**Continue:**

**Step 5️⃣: PostItemViewModel.updateItem() → Upload new images + Firestore update**

```swift
File: PostItemViewModel.swift (referenced)
Line: ~140-170 (approx)

func updateItem() async {
    guard let itemID = itemBeingEdited?.id else { return }
    guard validate() else { return }

    isLoading = true
    do {
        var imageURLs = existingImageURLs  // Keep existing images

        // Step 5a: Upload only new images
        if !selectedImages.isEmpty {
            let newImageURLs = try await StorageService.shared.uploadImages(
                selectedImages,
                folderPath: "item_images"
            )
            imageURLs.append(contentsOf: newImageURLs)
        }

        // Step 5b: Create updated Item
        let updatedItem = Item(
            id: itemID,
            title: title,
            description: description,
            price: price,
            category: selectedCategory,
            imageURLs: imageURLs,
            sellerID: itemBeingEdited?.sellerID ?? "",
            sellerName: itemBeingEdited?.sellerName ?? "",
            phone: itemBeingEdited?.phone ?? "",
            isAvailable: itemBeingEdited?.isAvailable ?? true,
            createdAt: itemBeingEdited?.createdAt ?? Timestamp(),
            updatedAt: Timestamp()  // ← New update timestamp
        )

        // Step 5c: Update Firestore
        try await FirestoreService.shared.updateItem(updatedItem)
        // ← Update existing document

        clearForm()
        didPostSuccessfully = true  // ← Success
    } catch {
        showErrorMessage(mapError(error))
    }
    isLoading = false
}
```

**Jump to FirestoreService.updateItem():**

```swift
File: FirestoreService.swift (referenced)

func updateItem(_ item: Item) async throws {
    try db.collection("items").document(item.id).setData(from: item)
    // ← LINE: Update existing document with new data
}
```

**Continue:**

**Step 6️⃣: Firestore update success → EditItemView dismiss**

```swift
File: EditItemView.swift (referenced)

if viewModel.didPostSuccessfully {
    dismiss()  // ← Close edit view
    onUpdate?()  // ← Callback to refresh MyAdsView
}
```

---

### 📊 FLOW 7 Summary:

| Step | File              | Function            | Action                                        |
| ---- | ----------------- | ------------------- | --------------------------------------------- |
| 1    | MyAdsView         | Edit button         | NavigationLink / Sheet open                   |
| 2    | MyAdsView         | Edit button         | EditItemView(item: selectedItem) pass         |
| 3    | EditItemView      | init                | @StateObject PostItemViewModel() create       |
| 4    | EditItemView      | onAppear            | viewModel.loadExistingItem(item)              |
| 5    | EditItemView      | form fields         | User edits title/desc/price/photos            |
| 6    | EditItemView      | button tap          | Task { await viewModel.updateItem() }         |
| 7    | PostItemViewModel | updateItem()        | existingImageURLs + selectedImages combine    |
| 8    | PostItemViewModel | updateItem()        | StorageService.uploadImages() for new ones    |
| 9    | PostItemViewModel | updateItem()        | Create Item with updated data + new Timestamp |
| 10   | PostItemViewModel | updateItem()        | FirestoreService.updateItem()                 |
| 11   | FirestoreService  | updateItem()        | db.collection("items").document(id).setData() |
| 12   | EditItemView      | didPostSuccessfully | dismiss() + onUpdate() callback               |

---

## **FLOW 8: Delete Item - Listing মুছে ফেলা**

### ↓ Step-by-Step Execution:

**User action: MyAdsView-এ "Delete" button tap**

**Step 1️⃣: MyAdsView → Delete button → Confirmation alert**

```swift
File: MyAdsView.swift
Line: 150-155

Button {
    itemToDelete = item               // ← LINE 151: Select item
    showDeleteConfirm = true          // ← LINE 152: Show confirmation
} label: {
    Label("Delete", systemImage: "trash")
}
```

**Continue:**

**Step 2️⃣: Confirmation dialog → User confirms**

```swift
File: MyAdsView.swift
Line: 54-65

.alert("Delete Item", isPresented: $showDeleteConfirm) {
    Button("Cancel", role: .cancel) {
        itemToDelete = nil
    }
    Button("Delete", role: .destructive) {
        if let item = itemToDelete {
            Task { await deleteItem(item) }  // ← LINE 60: Call deleteItem()
        }
    }
} message: {
    Text("Are you sure you want to delete \"\(itemToDelete?.title ?? "this item")\"? This action cannot be undone.")
}
```

**Continue:**

**Step 3️⃣: MyAdsView.deleteItem() → Delete images from Storage**

```swift
File: MyAdsView.swift
Line: 240-260

private func deleteItem(_ item: Item) async {
    guard let id = item.id else { return }

    do {
        // Step 3a: Delete images from Firebase Storage
        if !item.imageURLs.isEmpty {
            try? await StorageService.shared.deleteImages(urls: item.imageURLs)
            // ← LINE 246: Delete all image URLs from Storage
        }

        // Step 3b: Delete Firestore document
        try await FirestoreService.shared.deleteItem(byID: id)
        // ← LINE 250: Delete item document from Firestore

        // Step 3c: Refresh lists
        await loadMyItems()              // ← Reload MyAdsView items
        await itemViewModel.refresh()    // ← Refresh HomeView items
```

**Jump to StorageService.deleteImages():**

```swift
File: StorageService.swift (referenced)

func deleteImages(urls: [String]) async throws {
    for urlString in urls {
        if let url = URL(string: urlString) {
            let pathReference = storage.reference(forURL: urlString)
            try await pathReference.delete()
            // ← Delete each image from Firebase Storage
        }
    }
}
```

**Jump to FirestoreService.deleteItem():**

```swift
File: FirestoreService.swift (referenced)

func deleteItem(byID id: String) async throws {
    try await db.collection("items").document(id).delete()
    // ← Delete Firestore document
}
```

**Continue:**

**Step 4️⃣: All deleted → Items reloaded → UI update**

```swift
File: MyAdsView.swift
Line: 246-254

        await loadMyItems()              // ← Remove from myItems array
        await itemViewModel.refresh()    // ← Update HomeView

    } catch {
        errorMessage = "Failed to delete item: \(error.localizedDescription)"
        showError = true
    }

    itemToDelete = nil  // ← Clear selection
}
```

**Continue:**

**Step 5️⃣: HomeView and MyAdsView re-render without deleted item**

```swift
@Published var myItems: [Item] = []

// After refresh:
myItems = <new array without deleted item>
// ← LazyVGrid automatically updates
```

---

### 📊 FLOW 8 Summary:

| Step | File             | Function       | Action                                      |
| ---- | ---------------- | -------------- | ------------------------------------------- |
| 1    | MyAdsView        | Delete button  | itemToDelete = item assignment              |
| 2    | MyAdsView        | Delete button  | showDeleteConfirm = true                    |
| 3    | MyAdsView        | User confirm   | Alert Button("Delete") tap                  |
| 4    | MyAdsView        | Alert action   | Task { await deleteItem(item) }             |
| 5    | MyAdsView        | deleteItem()   | Extract item.id                             |
| 6    | MyAdsView        | deleteItem()   | Check item.imageURLs not empty              |
| 7    | MyAdsView        | deleteItem()   | StorageService.deleteImages(urls)           |
| 8    | StorageService   | deleteImages() | For each URL: storage.reference().delete()  |
| 9    | MyAdsView        | deleteItem()   | FirestoreService.deleteItem(byID)           |
| 10   | FirestoreService | deleteItem()   | db.collection("items").document().delete()  |
| 11   | MyAdsView        | deleteItem()   | await loadMyItems() refresh                 |
| 12   | MyAdsView        | deleteItem()   | await itemViewModel.refresh()               |
| 13   | MyAdsView        | @Published     | myItems array update → LazyVGrid re-render  |
| 14   | HomeView         | @Published     | filteredItems change → LazyVGrid disappears |

---

## **FLOW 9: Logout - একাউন্ট থেকে Sign Out করা**

### ↓ Step-by-Step Execution:

**User action: ProfileView-এ "Sign Out" button tap**

**Step 1️⃣: ProfileView → Sign Out button tap → Confirmation**

```swift
File: ProfileView.swift
Line: 82-100

Button(role: .destructive) {
    showSignOutConfirm = true  // ← LINE 85: Show confirmation dialog
} label: {
    HStack {
        Image(systemName: "rectangle.portrait.and.arrow.right")
        Text("Sign Out")
            .fontWeight(.semibold)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 14)
    .background(Color.red.opacity(0.1))
    .foregroundStyle(.red)
    .cornerRadius(12)
}
```

**Continue:**

**Step 2️⃣: Confirmation dialog → User confirms**

```swift
File: ProfileView.swift
Line: 106-115

.confirmationDialog("Sign Out", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
    Button("Sign Out", role: .destructive) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        authViewModel.signOut()  // ← LINE 110: authViewModel.signOut() call
    }
    Button("Cancel", role: .cancel) {}
} message: {
    Text("Are you sure you want to sign out?")
}
```

**Jump to AuthViewModel.signOut():**

```swift
File: AuthViewModel.swift
Line: 158-168

func signOut() {
    do {
        try AuthService.shared.signOut()  // ← LINE 160: Call service
        currentUser = nil                  // ← LINE 161: Clear user
        clearLoginFields()                 // ← LINE 162: Clear fields
        clearSignupFields()                // ← LINE 163: Clear fields
    } catch {
        showErrorMessage("Failed to sign out: \(error.localizedDescription)")
    }
}
```

**Continue:**

**Step 3️⃣: AuthService.signOut() → Firebase sign out**

```swift
File: AuthService.swift
Line: 57-59

func signOut() throws {
    try auth.signOut()  // ← LINE 58: Firebase Auth signOut()
}
```

**কী হয়:**

- `auth.signOut()` Firebase-এ current user clear করে
- Auth state listener trigger হওয়ার জন্য set করে

**Continue:**

**Step 4️⃣: Firebase signOut → Auth state listener trigger**

```swift
File: AuthViewModel.swift
Line: 46-53 (listener setup)

authListenerHandle = AuthService.shared.addAuthStateListener { [weak self] loggedIn in
    Task { @MainActor in
        self?.isLoggedIn = loggedIn  // ← Now false
        if loggedIn {
            self?.fetchUser()
        } else {
            self?.currentUser = nil  // ← Clear user on logout
        }
    }
}
```

**Continue:**

**Step 5️⃣: isLoggedIn = false → ContentView conditional render change**

```swift
File: ContentView.swift
Line: 18-28

ZStack {
    Group {
        if authViewModel.isCheckingAuth {
            LaunchScreenView()
        } else if authViewModel.isLoggedIn {
            MainTabView()
                .environmentObject(authViewModel)
        } else {
            // ← Now renders LoginView
            AuthSwitchView()  // Shows login/signup choice
        }
    }
    .transition(.opacity)
    .animation(.easeInOut(duration: 0.3), value: authViewModel.isLoggedIn)
}
```

**কী হয়:**

- `isLoggedIn` false → body re-evaluates
- `else` branch renders (AuthSwitchView / LoginView)
- MainTabView disappear হয়
- User login screen এ আসে

---

### 📊 FLOW 9 Summary:

| Step | File          | Function          | Action                                                   |
| ---- | ------------- | ----------------- | -------------------------------------------------------- |
| 1    | ProfileView   | button tap        | showSignOutConfirm = true                                |
| 2    | ProfileView   | User confirm      | ConfirmationDialog Button tap                            |
| 3    | ProfileView   | Dialog action     | UINotificationFeedbackGenerator().notificationOccurred() |
| 4    | ProfileView   | Dialog action     | authViewModel.signOut()                                  |
| 5    | AuthViewModel | signOut()         | AuthService.shared.signOut()                             |
| 6    | AuthService   | signOut()         | auth.signOut()                                           |
| 7    | Firebase      | (internal)        | Current user session clear                               |
| 8    | AuthViewModel | listener callback | isLoggedIn = false detect                                |
| 9    | AuthViewModel | listener callback | currentUser = nil                                        |
| 10   | ContentView   | observer          | isLoggedIn change detect → body re-render                |
| 11   | ContentView   | body              | else branch render → AuthSwitchView/LoginView show       |
| 12   | UI            | animation         | Opacity animation transition                             |
| 13   | User          | view change       | MainTabView অদৃশ্য → LoginView দৃশ্যমান                  |

---

## 📋 **Section 13 Complete: All 9 Flows Documented!**

### Summary of All Flows:

| #   | Flow           | Entry Point              | Key Files                               | Action                                                    |
| --- | -------------- | ------------------------ | --------------------------------------- | --------------------------------------------------------- |
| 1   | App Launch     | KUET_TradeApp            | FirebaseApp, ContentView, AuthViewModel | Firebase config → Auth listener → MainTabView/LoginView   |
| 2   | Login          | LoginView                | AuthViewModel, AuthService, Firebase    | Validation → signIn → Firestore fetch → MainTabView       |
| 3   | Sign Up        | SignUpView               | AuthViewModel, AuthService              | Validation → createUser → Firestore save → MainTabView    |
| 4   | Browse Items   | MainTabView/HomeView     | ItemViewModel, FirestoreService         | Initialize → loadItems → applyFilters → grid display      |
| 5   | Post Item      | MainTabView/PostItemView | PostItemViewModel, StorageService       | Form fill → validate → upload images → Firestore save     |
| 6   | Contact Seller | ItemDetailView           | ContactSellerButton                     | Button tap → URL scheme → Phone/WhatsApp/SMS app          |
| 7   | Edit Item      | MyAdsView/EditItemView   | PostItemViewModel, FirestoreService     | Load existing → form edit → updateItem → Firestore update |
| 8   | Delete Item    | MyAdsView                | StorageService, FirestoreService        | Confirm → delete images → delete Firestore doc → refresh  |
| 9   | Logout         | ProfileView              | AuthViewModel, AuthService, Firebase    | Confirm → signOut → listener triggers → LoginView show    |

---

**✅ Documentation Complete!**

All 9 major user journeys documented with:

- Code-level tracing (exact file names + line numbers)
- Step-by-step execution flow
- Bengali explanations (কী হয়:)
- Code snippets for each critical operation
- Summary execution tables
- Service/ViewModel/View integration paths

Ready for presentation or interview! 🎓🚀

---

## 14) Teammate UI Work Division (3 Parts)

এই section teacher-কে explain করার জন্য: project UI-based ভাবে 3 teammate-এর মধ্যে কিভাবে ভাগ করা হয়েছে।

### 14.1) Part A - Authentication + App Entry UI

**Teammate A-এর UI scope:**

- App start, auth gate, login/signup/reset flow

**Primary UI files:**

- `KUET_Trade/KUET_TradeApp.swift`
- `KUET_Trade/ContentView.swift`
- `KUET_Trade/Views/Auth/LoginView.swift`
- `KUET_Trade/Views/Auth/SignUpView.swift`
- `KUET_Trade/Views/Auth/ForgotPasswordView.swift`
- `KUET_Trade/Views/Components/LaunchScreenView.swift`

**Teacher-কে বলার মতো feature ownership:**

- Firebase initialize করে app launch setup
- Auth checking অনুযায়ী screen switch (Launch/Login/Main Tabs)
- Login, Signup, Forgot Password UI and form interactions
- Auth error alert/validation feedback UI

---

### 14.2) Part B - Marketplace Browsing UI (Buyer Side)

**Teammate B-এর UI scope:**

- Home browsing experience, item discovery, item details, contact actions

**Primary UI files:**

- `KUET_Trade/Views/MainTabView.swift` (Home tab integration)
- `KUET_Trade/Views/Home/HomeView.swift`
- `KUET_Trade/Views/Home/ItemCardView.swift`
- `KUET_Trade/Views/Home/ItemDetailView.swift`
- `KUET_Trade/Views/Search/SearchFilterView.swift`
- `KUET_Trade/Views/Components/ContactSellerButton.swift`
- `KUET_Trade/Views/Components/ShimmerView.swift`
- `KUET_Trade/Views/Components/ImagePicker.swift` (browse/detail contexts where used)

**Teacher-কে বলার মতো feature ownership:**

- Item list/grid UI rendering
- Search, category, price, sort filter UI
- Item detail page with seller info
- Call/WhatsApp/SMS contact action UI
- Loading placeholder/skeleton UX

---

### 14.3) Part C - Seller + Profile Management UI

**Teammate C-এর UI scope:**

- Posting/editing ads, my ads management, profile and sign-out

**Primary UI files:**

- `KUET_Trade/Views/MainTabView.swift` (Post/My Ads/Profile tab integration)
- `KUET_Trade/Views/Post/PostItemView.swift`
- `KUET_Trade/Views/Post/EditItemView.swift`
- `KUET_Trade/Views/Profile/MyAdsView.swift`
- `KUET_Trade/Views/Profile/ProfileView.swift`
- `KUET_Trade/Views/Components/OfflineBannerView.swift` (network-aware UX in main shell)

**Teacher-কে বলার মতো feature ownership:**

- New ad পোস্ট করার full form UI
- Existing ad edit/delete/sold-relist management UI
- My Ads list and item action controls
- Profile page + app share + sign out flow
- Offline banner integration in main user shell

---

### 14.4) Teacher Presentation Script (Short)

আপনি viva/defense এ এভাবে বলতে পারেন:

1. **"আমরা project UI-কে 3টা module-এ ভাগ করেছি।"**
2. **"Part A (Teammate A) auth এবং app entry UI করেছে - login/signup/forgot password + launch/auth gate।"**
3. **"Part B (Teammate B) buyer-side marketplace browsing UI করেছে - home, search/filter, item detail, contact seller।"**
4. **"Part C (Teammate C) seller/profile management UI করেছে - post ad, edit/delete/sold, my ads, profile/sign out।"**
5. **"সবার কাজ MainTabView এবং shared ViewModels/Services-এর সাথে integrate করা হয়েছে।"**

---

### 14.5) One-Line Division Table

| Teammate | UI Part            | Core Screens                                                |
| -------- | ------------------ | ----------------------------------------------------------- |
| A        | Auth + App Entry   | Launch, Login, Sign Up, Forgot Password                     |
| B        | Browse + Discovery | Home, Item Card, Item Detail, Search/Filter, Contact Seller |
| C        | Seller + Profile   | Post Item, Edit Item, My Ads, Profile, Sign Out             |

---

### 14.6) Equal-Mark Distribution Plan

এই ভাগটা এমনভাবে রাখা হয়েছে যাতে 3 জনের কাজের scope প্রায় সমান হয় এবং teacher-এর সামনে fairness explain করা যায়।

| Member   | Equal Scope                       | What to Present                                                  |
| -------- | --------------------------------- | ---------------------------------------------------------------- |
| Member 1 | Authentication + onboarding       | App launch, login, signup, forgot password, auth state switching |
| Member 2 | Marketplace browsing + search     | Home screen, filters, item cards, item detail, contact seller    |
| Member 3 | Seller tools + profile management | Post ad, edit item, my ads, delete/sold flows, profile/sign out  |

**Why this is balanced:**

- তিনজনই major UI flows cover করছে
- প্রত্যেকের অংশে screen + logic + user interaction আছে
- এক জন শুধু design না, এক জন শুধু backend না, বরং UI flow অনুযায়ী balanced ownership আছে

---

### 14.7) Current UI Limitations We Can Tell Teacher

বর্তমান screenshots দেখে যে limitation গুলো teacher-কে বলা যায়:

- **No role-based seller/account type UI**: এখন buyer/seller আলাদা badge বা account selection নেই
- **No item detail mock with full data**: বর্তমানে home এবং empty state screens বেশি visible, তাই detail depth এখনও limited
- **No chat or in-app messaging**: seller contact শুধু call/WhatsApp/SMS-এর মাধ্যমে হচ্ছে
- **No admin panel**: moderation, approval, or reporting dashboard নেই
- **No rating/review system**: buyer feedback or seller rating UI নেই
- **No dark mode/custom theme layer**: app clean আছে, but more branded visual polish future improvement হতে পারে
- **Post image storage edge case**: upload path issue দেখা গিয়েছিল, যা এখন fix করা হয়েছে; further upload retry handling add করা যায়

---

### 14.8) What We Will Update Next

next updates হিসেবে teacher-কে বলতে পারো:

1. **Seller account type / role UI** add করা হবে
2. **Item detail screen** আরও rich করা হবে with better gallery and actions
3. **In-app chat or inquiry flow** add করা হবে
4. **Admin moderation support** যোগ করা হবে
5. **Better empty/loading states** and retry UI polish করা হবে
6. **Profile customization** (profile photo, bio, more settings) add করা হবে

---

**Note:** Name বসানোর সময় Teammate A/B/C এর জায়গায় real নাম replace করে দিলেই final submission-ready হয়ে যাবে。
