//
//  CloudinaryService.swift
//  KUET_Trade
//
//  Created by Torikul on 10/4/26.
//

import Foundation
import UIKit
import Cloudinary

final class CloudinaryService {
    static let shared = CloudinaryService()

    private let cloudinary: CLDCloudinary

    private init() {
        let config = CLDConfiguration(
            cloudName: AppConstants.Cloudinary.cloudName,
            secure: true
        )
        cloudinary = CLDCloudinary(configuration: config)
    }

    // MARK: - Upload Single Image
    func uploadImage(_ image: UIImage, folder: String = AppConstants.Cloudinary.defaultFolder) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw CloudinaryError.compressionFailed
        }

        let uploadPreset = AppConstants.Cloudinary.uploadPreset.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !uploadPreset.isEmpty else {
            throw CloudinaryError.missingUploadPreset
        }

        do {
            return try await uploadWithFolder(imageData: imageData, uploadPreset: uploadPreset, folder: folder)
        } catch {
            // Some Cloudinary configurations (for example dynamic folder mode)
            // can reject explicit folder params for unsigned uploads.
            return try await uploadWithoutFolder(imageData: imageData, uploadPreset: uploadPreset)
        }
    }

    // MARK: - Upload Multiple Images
    func uploadImages(_ images: [UIImage], folder: String = AppConstants.Cloudinary.defaultFolder) async throws -> [String] {
        var urls: [String] = []
        urls.reserveCapacity(images.count)

        for image in images {
            let url = try await uploadImage(image, folder: folder)
            urls.append(url)
        }

        return urls
    }

    // MARK: - Delete Image by Public ID
    func deleteImage(publicId: String) async throws {
        throw CloudinaryError.deletionNotSupported
    }

    // MARK: - Delete Multiple Images by Public IDs
    func deleteImages(publicIds: [String]) async throws {
        guard !publicIds.isEmpty else { return }
        throw CloudinaryError.deletionNotSupported
    }

    // MARK: - Delete Multiple Images by URLs
    func deleteImages(urls: [String]) async throws {
        guard !urls.isEmpty else { return }
        throw CloudinaryError.deletionNotSupported
    }
}

private extension CloudinaryService {
    func uploadWithFolder(imageData: Data, uploadPreset: String, folder: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            let params = CLDUploadRequestParams()
            params.setFolder(folder)

            cloudinary.createUploader().upload(
                data: imageData,
                uploadPreset: uploadPreset,
                params: params
            ) { result, error in
                if let error {
                    continuation.resume(throwing: CloudinaryError.uploadFailed(error.localizedDescription))
                    return
                }

                guard let secureUrl = result?.secureUrl, !secureUrl.isEmpty else {
                    continuation.resume(throwing: CloudinaryError.noURL)
                    return
                }

                continuation.resume(returning: secureUrl)
            }
        }
    }

    func uploadWithoutFolder(imageData: Data, uploadPreset: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            cloudinary.createUploader().upload(
                data: imageData,
                uploadPreset: uploadPreset
            ) { result, error in
                if let error {
                    continuation.resume(throwing: CloudinaryError.uploadFailed(error.localizedDescription))
                    return
                }

                guard let secureUrl = result?.secureUrl, !secureUrl.isEmpty else {
                    continuation.resume(throwing: CloudinaryError.noURL)
                    return
                }

                continuation.resume(returning: secureUrl)
            }
        }
    }
}

// MARK: - Cloudinary Errors
enum CloudinaryError: LocalizedError {
    case compressionFailed
    case missingUploadPreset
    case uploadFailed(String)
    case noURL
    case deletionNotSupported

    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return "Failed to compress image."
        case .missingUploadPreset:
            return "Cloudinary upload preset is missing. Set AppConstants.Cloudinary.uploadPreset first."
        case .uploadFailed(let message):
            return "Upload failed: \(message)"
        case .noURL:
            return "Failed to get uploaded image URL."
        case .deletionNotSupported:
            return "Image deletion is not supported from client-side unsigned uploads."
        }
    }
}
