//
//  EditItemView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI
import UIKit

struct EditItemView: View {
    @StateObject private var viewModel = PostItemViewModel()
    @Environment(\.dismiss) private var dismiss
    let item: Item
    var onUpdate: (() -> Void)? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Existing Images
                if !viewModel.existingImageURLs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label("Current Photos", systemImage: "photo.stack")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text("\(viewModel.totalImageCount)/\(AppConstants.Validation.maxImages)")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.existingImageURLs.indices, id: \.self) { index in
                                    ZStack(alignment: .topTrailing) {
                                        AsyncImage(url: URL(string: viewModel.existingImageURLs[index])) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                            case .failure:
                                                Color(.systemGray5)
                                                    .overlay {
                                                        Image(systemName: "photo")
                                                            .foregroundStyle(.secondary)
                                                    }
                                            case .empty:
                                                ProgressView()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .background(Color(.systemGray6))
                                            @unknown default:
                                                Color(.systemGray5)
                                            }
                                        }
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(12)
                                        
                                        Button {
                                            viewModel.removeExistingImage(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title3)
                                                .foregroundStyle(.white)
                                                .background(Circle().fill(Color.red.opacity(0.8)))
                                        }
                                        .offset(x: 4, y: -4)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // MARK: - New Images Section
                VStack(alignment: .leading, spacing: 8) {
                    Label("Add New Photos", systemImage: "photo.on.rectangle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            // Add Photo Button
                            if viewModel.canAddMore {
                                Button {
                                    viewModel.showImageSourcePicker = true
                                } label: {
                                    VStack(spacing: 6) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title)
                                        Text("Add Photo")
                                            .font(.caption2)
                                    }
                                    .foregroundStyle(Color.accentColor)
                                    .frame(width: 100, height: 100)
                                    .background(Color.accentColor.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                            
                            // Newly Selected Images
                            ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: viewModel.selectedImages[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                        .cornerRadius(12)
                                    
                                    Button {
                                        viewModel.removeImage(at: index)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title3)
                                            .foregroundStyle(.white)
                                            .background(Circle().fill(Color.black.opacity(0.5)))
                                    }
                                    .offset(x: 4, y: -4)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // MARK: - Title
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Label("Title", systemImage: "textformat")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(viewModel.titleCharCount)
                            .font(.caption2)
                            .foregroundStyle(viewModel.title.count > AppConstants.Validation.maxTitleLength ? .red : .secondary)
                    }
                    
                    TextField("e.g. Data Structures Textbook", text: $viewModel.title)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal)
                
                // MARK: - Description
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Label("Description", systemImage: "text.alignleft")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(viewModel.descCharCount)
                            .font(.caption2)
                            .foregroundStyle(viewModel.description.count > AppConstants.Validation.maxDescriptionLength ? .red : .secondary)
                    }
                    
                    TextEditor(text: $viewModel.description)
                        .frame(minHeight: 100)
                        .padding(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.separator), lineWidth: 0.5)
                        )
                        .overlay(alignment: .topLeading) {
                            if viewModel.description.isEmpty {
                                Text("Describe your item — condition, usage, etc.")
                                    .foregroundStyle(Color(.placeholderText))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 12)
                                    .allowsHitTesting(false)
                            }
                        }
                }
                .padding(.horizontal)
                
                // MARK: - Price
                VStack(alignment: .leading, spacing: 6) {
                    Label("Price (৳)", systemImage: "bangladeshitakasign")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    TextField("e.g. 500", text: $viewModel.priceText)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal)
                
                // MARK: - Category
                VStack(alignment: .leading, spacing: 6) {
                    Label("Category", systemImage: "tag.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(ItemCategory.allCases) { category in
                                Button {
                                    viewModel.selectedCategory = category
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: category.icon)
                                            .font(.caption)
                                        Text(category.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(viewModel.selectedCategory == category ? Color.accentColor : Color(.secondarySystemGroupedBackground))
                                    .foregroundStyle(viewModel.selectedCategory == category ? .white : .primary)
                                    .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Update Button
                Button {
                    Task {
                        await viewModel.updateItem()
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
                .disabled(viewModel.isLoading)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .padding(.top, 8)
        }
        .navigationTitle("Edit Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            viewModel.loadItem(item)
        }
        .onChange(of: viewModel.didEditSuccessfully) { _, success in
            if success {
                onUpdate?()
                dismiss()
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
        .sheet(isPresented: $viewModel.showPhotoLibrary) {
            ImagePicker(image: $viewModel.pickedImage, sourceType: .photoLibrary)
        }
        .fullScreenCover(isPresented: $viewModel.showCamera) {
            ImagePicker(image: $viewModel.pickedImage, sourceType: .camera)
        }
        .confirmationDialog("Add Photo", isPresented: $viewModel.showImageSourcePicker, titleVisibility: .visible) {
            Button("Photo Library") {
                viewModel.showPhotoLibrary = true
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Camera") {
                    viewModel.showCamera = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    NavigationStack {
        EditItemView(item: Item(
            id: "1",
            title: "Sample Textbook",
            description: "Good condition",
            price: 350,
            category: .books,
            imageURLs: [],
            sellerID: "abc",
            sellerName: "Himel",
            sellerPhone: "01712345678"
        ))
    }
}
