//
//  FirestoreService.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import Foundation
import FirebaseFirestore

class FirestoreService {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - Items Collection Reference
    private var itemsCollection: CollectionReference {
        db.collection("items")
    }
    
    // MARK: - Create Item
    func createItem(_ item: Item) async throws -> String {
        let docRef = try itemsCollection.addDocument(from: item)
        return docRef.documentID
    }
    
    // MARK: - Fetch All Available Items
    func fetchAllItems() async throws -> [Item] {
        let snapshot = try await itemsCollection.getDocuments()
        
        var items = snapshot.documents.compactMap { doc in
            try? doc.data(as: Item.self)
        }
        
        items = items.filter { $0.isAvailable }
        items.sort { $0.createdAt > $1.createdAt }
        
        return items
    }
    
    // MARK: - Fetch Items by Category
    func fetchItems(byCategory category: ItemCategory) async throws -> [Item] {
        let snapshot = try await itemsCollection.getDocuments()
        
        var items = snapshot.documents.compactMap { doc in
            try? doc.data(as: Item.self)
        }
        
        items = items.filter { $0.isAvailable && $0.category == category }
        items.sort { $0.createdAt > $1.createdAt }
        
        return items
    }
    
    // MARK: - Fetch Items by Seller (My Ads)
    func fetchUserItems(userID: String) async throws -> [Item] {
        let snapshot = try await itemsCollection.getDocuments()
        
        var items = snapshot.documents.compactMap { doc in
            try? doc.data(as: Item.self)
        }
        
        items = items.filter { $0.sellerID == userID }
        items.sort { $0.createdAt > $1.createdAt }
        
        return items
    }
    
    // MARK: - Fetch Single Item
    func fetchItem(byID id: String) async throws -> Item? {
        let document = try await itemsCollection.document(id).getDocument()
        return try document.data(as: Item.self)
    }
    
    // MARK: - Update Item
    func updateItem(_ item: Item) async throws {
        guard let id = item.id else { throw FirestoreError.missingID }
        try itemsCollection.document(id).setData(from: item, merge: true)
    }
    
    // MARK: - Delete Item
    func deleteItem(byID id: String) async throws {
        try await itemsCollection.document(id).delete()
    }
    
    // MARK: - Toggle Availability (Mark as Sold)
    func toggleAvailability(itemID: String, isAvailable: Bool) async throws {
        try await itemsCollection.document(itemID).updateData([
            "isAvailable": isAvailable,
            "updatedAt": Timestamp(date: Date())
        ])
    }
}

// MARK: - Firestore Errors
enum FirestoreError: LocalizedError {
    case missingID
    case encodingFailed
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .missingID:
            return "Document ID is missing."
        case .encodingFailed:
            return "Failed to encode data."
        case .decodingFailed:
            return "Failed to decode data."
        }
    }
}
