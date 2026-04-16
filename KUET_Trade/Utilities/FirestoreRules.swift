//
//  FirestoreRules.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//
//  ⚠️ This file is a REFERENCE ONLY — not executed in the app.
//  Copy these rules to your Firebase Console:
//  - Firestore Database → Rules
//  - Storage → Rules
//

import Foundation

// swiftlint:disable all

/// Reference: Recommended Firestore Security Rules
///
/// ```
/// rules_version = '2';
/// service cloud.firestore {
///   match /databases/{database}/documents {
///
///     // ── Users Collection ──
///     match /users/{userId} {
///       // Anyone authenticated can read user profiles
///       allow read: if request.auth != null;
///
///       // Only the user themselves can create/update their profile
///       allow create: if request.auth != null && request.auth.uid == userId;
///       allow update: if request.auth != null && request.auth.uid == userId;
///
///       // Users cannot delete their profile (admin only)
///       allow delete: if false;
///     }
///
///     // ── Items Collection ──
///     match /items/{itemId} {
///       // Anyone authenticated can read items
///       allow read: if request.auth != null;
///
///       // Authenticated users can create items (seller must be themselves)
///       allow create: if request.auth != null
///                     && request.resource.data.sellerID == request.auth.uid;
///
///       // Only the item seller can update their own item
///       allow update: if request.auth != null
///                     && resource.data.sellerID == request.auth.uid;
///
///       // Only the item seller can delete their own item
///       allow delete: if request.auth != null
///                     && resource.data.sellerID == request.auth.uid;
///     }
///
///     // ── Buy Requests Collection ──
///     match /buyRequests/{requestId} {
///       // Authenticated users can read active requests
///       allow read: if request.auth != null;
///
///       // Buyer can create own request
///       allow create: if request.auth != null
///                     && request.resource.data.buyerId == request.auth.uid;
///
///       // Buyer can update/delete only own request
///       allow update, delete: if request.auth != null
///                             && resource.data.buyerId == request.auth.uid;
///     }
///
///     // ── Reviews Collection ──
///     match /reviews/{reviewId} {
///       // Authenticated users can read
///       allow read: if request.auth != null;
///
///       // Reviewer can create only for themselves
///       allow create: if request.auth != null
///                     && request.resource.data.reviewerId == request.auth.uid;
///
///       // Reviewer can edit/delete own review only
///       allow update, delete: if request.auth != null
///                             && resource.data.reviewerId == request.auth.uid;
///     }
///
///     // ── Conversations Collection ──
///     match /conversations/{conversationId} {
///       // Only participants can read/write
///       allow read, write: if request.auth != null
///                          && request.auth.uid in resource.data.participants;
///
///       // Create allowed when caller is a participant
///       allow create: if request.auth != null
///                     && request.auth.uid in request.resource.data.participants;
///
///       // ── Messages Subcollection ──
///       match /messages/{messageId} {
///         // Participants only
///         allow read, write: if request.auth != null
///                            && request.auth.uid in get(/databases/$(database)/documents/conversations/$(conversationId)).data.participants;
///       }
///     }
///   }
/// }
/// ```
///
/// Reference: Recommended Storage Security Rules
///
/// ```
/// rules_version = '2';
/// service firebase.storage {
///   match /b/{bucket}/o {
///
///     // ── Item Images ──
///     match /item_images/{userId}/{allPaths=**} {
///       // Anyone authenticated can read item images
///       allow read: if request.auth != null;
///
///       // Only the owner can upload (max 5MB, images only)
///       allow write: if request.auth != null
///                    && request.auth.uid == userId
///                    && request.resource.size < 5 * 1024 * 1024
///                    && request.resource.contentType.matches('image/.*');
///
///       // Only the owner can delete their images
///       allow delete: if request.auth != null
///                     && request.auth.uid == userId;
///     }
///
///     // ── Profile Images ──
///     match /profile_images/{userId}/{allPaths=**} {
///       // Anyone authenticated can read profile images
///       allow read: if request.auth != null;
///
///       // Only the owner can upload (max 2MB, images only)
///       allow write: if request.auth != null
///                    && request.auth.uid == userId
///                    && request.resource.size < 2 * 1024 * 1024
///                    && request.resource.contentType.matches('image/.*');
///
///       // Only the owner can delete
///       allow delete: if request.auth != null
///                     && request.auth.uid == userId;
///     }
///   }
/// }
/// ```

// swiftlint:enable all
