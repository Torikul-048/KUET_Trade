//
//  PostItemViewModel.swift
//  KUET_Trade
//
//  Created by Torikul on 1/3/26.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
class PostItemViewModel: ObservableObject {
    
    // MARK: - Form Fields
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var priceText: String = ""
    @Published var selectedCategory: ItemCategory = .others
    @Published var selectedImages: [UIImage] = []
    
    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var didPostSuccessfully: Bool = false
    @Published var didEditSuccessfully: Bool = false
    
    // MARK: - Image Picker State
    @Published var showImageSourcePicker: Bool = false
    @Published var showCamera: Bool = false
    @Published var showPhotoLibrary: Bool = false
    @Published var pickedImage: UIImage? = nil {
        didSet {
            if let img = pickedImage {
                addImage(img)
                pickedImage = nil
            }
        }
    }
    
    // MARK: - Edit Mode
    var editingItem: Item? = nil
    var existingImageURLs: [String] = []
    
    var isEditMode: Bool {
        editingItem != nil
    }
    
    // MARK: - Computed
    var price: Double {
        Double(priceText) ?? 0
    }
    
    var canAddMoreImages: Bool {
        selectedImages.count < AppConstants.Validation.maxImages
    }
    
    var titleCharCount: String {
        "\(title.count)/\(AppConstants.Validation.maxTitleLength)"
    }
    
    var descCharCount: String {
        "\(description.count)/\(AppConstants.Validation.maxDescriptionLength)"
    }
    
    // MARK: - Load Item for Editing
    func loadItem(_ item: Item) {
        editingItem = item
        title = item.title
        description = item.description
        priceText = String(format: "%.0f", item.price)
        selectedCategory = item.category
        existingImageURLs = item.imageURLs
        // Note: existing images are shown by URL, new images added via selectedImages
    }
    
    // MARK: - Add Image
    func addImage(_ image: UIImage) {
        guard canAddMoreImages else { return }
        selectedImages.append(image)
    }
    
    // MARK: - Remove Image
    func removeImage(at index: Int) {
        guard index < selectedImages.count else { return }
        selectedImages.remove(at: index)
    }
    
    // MARK: - Remove Existing Image URL (Edit Mode)
    func removeExistingImage(at index: Int) {
        guard index < existingImageURLs.count else { return }
        existingImageURLs.remove(at: index)
    }
    
    // MARK: - Total Image Count (new + existing)
    var totalImageCount: Int {
        selectedImages.count + existingImageURLs.count
    }
    
    var canAddMore: Bool {
        totalImageCount < AppConstants.Validation.maxImages
    }
    
    // MARK: - Validation
    private func validate() -> Bool {
        let trimmedTitle = title.trimmed
        let trimmedDesc = description.trimmed
        
        if trimmedTitle.isEmpty {
            showErrorMessage("Please enter a title.")
            return false
        }
        if trimmedTitle.count > AppConstants.Validation.maxTitleLength {
            showErrorMessage("Title must be \(AppConstants.Validation.maxTitleLength) characters or less.")
            return false
        }
        if trimmedDesc.isEmpty {
            showErrorMessage("Please enter a description.")
            return false
        }
        if trimmedDesc.count > AppConstants.Validation.maxDescriptionLength {
            showErrorMessage("Description must be \(AppConstants.Validation.maxDescriptionLength) characters or less.")
            return false
        }
        if priceText.trimmed.isEmpty || price <= 0 {
            showErrorMessage("Please enter a valid price.")
            return false
        }
        if price > AppConstants.Validation.maxPrice {
            showErrorMessage("Price cannot exceed ৳\(String(format: "%.0f", AppConstants.Validation.maxPrice)).")
            return false
        }
        if totalImageCount == 0 && !isEditMode {
            showErrorMessage("Please add at least one photo.")
            return false
        }
        return true
    }
    
    // MARK: - Post New Item
    func postItem() async {
        guard validate() else { return }
        
        guard let currentUser = AuthViewModel.shared.currentUser else {
            showErrorMessage("You must be logged in to post.")
            return
        }
        
        isLoading = true
        
        do {
            // 1. Upload images
            var imageURLs: [String] = []
            if !selectedImages.isEmpty {
                let folderPath = "\(AppConstants.StoragePaths.itemImages)/\(currentUser.uid)/\(UUID().uuidString)"
                imageURLs = try await uploadImagesWithFallback(selectedImages, folderPath: folderPath)
            }
            
            // 2. Create item
            let newItem = Item(
                title: title.trimmed,
                description: description.trimmed,
                price: price,
                category: selectedCategory,
                imageURLs: imageURLs,
                sellerID: currentUser.uid,
                sellerName: currentUser.name,
                sellerPhone: currentUser.phone
            )
            
            let _ = try await FirestoreService.shared.createItem(newItem)
            
            // 3. Success
            clearForm()
            didPostSuccessfully = true
            
        } catch {
            showErrorMessage("Failed to post item: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Update Existing Item
    func updateItem() async {
        guard validate() else { return }
        guard var item = editingItem else {
            showErrorMessage("No item to update.")
            return
        }
        
        isLoading = true
        
        do {
            // 1. Upload any new images
            var finalURLs = existingImageURLs
            if !selectedImages.isEmpty {
                let folderPath = "\(AppConstants.StoragePaths.itemImages)/\(item.sellerID)/\(UUID().uuidString)"
                let newURLs = try await uploadImagesWithFallback(selectedImages, folderPath: folderPath)
                finalURLs.append(contentsOf: newURLs)
            }
            
            // 2. Delete removed images from storage
            let removedURLs = item.imageURLs.filter { !existingImageURLs.contains($0) }
            if !removedURLs.isEmpty {
                // Cloudinary unsigned uploads should be deleted via backend/admin API.
                // Keep removed URLs out of the item document so they no longer appear in-app.
            }
            
            // 3. Update item fields
            item.title = title.trimmed
            item.description = description.trimmed
            item.price = price
            item.category = selectedCategory
            item.imageURLs = finalURLs
            item.updatedAt = Date()
            
            try await FirestoreService.shared.updateItem(item)
            
            // 4. Success
            didEditSuccessfully = true
            
        } catch {
            showErrorMessage("Failed to update item: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    // MARK: - Clear Form
    func clearForm() {
        title = ""
        description = ""
        priceText = ""
        selectedCategory = .others
        selectedImages = []
        existingImageURLs = []
        editingItem = nil
    }
    
    // MARK: - Error Helper
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }

    // MARK: - Upload Fallback
    private func uploadImagesWithFallback(_ images: [UIImage], folderPath: String) async throws -> [String] {
        do {
            return try await StorageService.shared.uploadImages(images, folderPath: folderPath)
        } catch {
            // Fallback for Firebase Storage issues.
            return try await CloudinaryService.shared.uploadImages(images, folder: folderPath)
        }
    }
}
