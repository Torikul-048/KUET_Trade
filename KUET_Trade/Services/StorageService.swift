//
//  StorageService.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import Foundation
import FirebaseStorage
import UIKit

class StorageService {
    static let shared = StorageService()
    private let storage = Storage.storage()
    
    private init() {}
    
    // MARK: - Upload Image
    func uploadImage(_ image: UIImage, path: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw StorageError.compressionFailed
        }
        
        let ref = storage.reference().child(path)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        var lastError: Error?
        for attempt in 1...3 {
            do {
                _ = try await ref.putDataAsync(imageData, metadata: metadata)
                let downloadURL = try await ref.downloadURL()
                return downloadURL.absoluteString
            } catch {
                lastError = error
                let message = error.localizedDescription.lowercased()

                // Occasionally metadata/read path lags right after upload on some setups.
                // Retry a couple of times before failing.
                if message.contains("does not exist") && attempt < 3 {
                    try await Task.sleep(nanoseconds: 400_000_000)
                    continue
                }

                throw error
            }
        }

        throw StorageError.objectNotFoundAfterUpload(path: path, reason: lastError?.localizedDescription ?? "Unknown error")
    }
    
    // MARK: - Upload Multiple Images
    func uploadImages(_ images: [UIImage], folderPath: String) async throws -> [String] {
        var urls: [String] = []
        
        for (index, image) in images.enumerated() {
            let path = "\(folderPath)/image_\(index)_\(UUID().uuidString).jpg"
            let url = try await uploadImage(image, path: path)
            urls.append(url)
        }
        
        return urls
    }
    
    // MARK: - Delete Image by URL
    func deleteImage(url: String) async throws {
        let ref = storage.reference(forURL: url)
        try await ref.delete()
    }
    
    // MARK: - Delete Multiple Images
    func deleteImages(urls: [String]) async throws {
        for url in urls {
            try await deleteImage(url: url)
        }
    }
}

// MARK: - Storage Errors
enum StorageError: LocalizedError {
    case compressionFailed
    case uploadFailed
    case downloadURLFailed
    case objectNotFoundAfterUpload(path: String, reason: String)
    
    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return "Failed to compress image."
        case .uploadFailed:
            return "Failed to upload image."
        case .downloadURLFailed:
            return "Failed to get download URL."
        case .objectNotFoundAfterUpload(let path, let reason):
            return "Upload completed but file lookup failed at '\(path)'. Check Firebase Storage bucket/rules. Details: \(reason)"
        }
    }
}
