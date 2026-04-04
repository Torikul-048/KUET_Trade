//
//  PostItemView.swift
//  KUET_Trade
//
//  Created by Himel on 1/3/26.
//

import SwiftUI
import UIKit

struct PostItemView: View {
    @StateObject private var viewModel = PostItemViewModel()
    @ObservedObject var itemViewModel: ItemViewModel
    @State private var hasAttemptedSubmit: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.didPostSuccessfully {
                    // MARK: - Success State
                    postSuccessView
                } else {
                    // MARK: - Post Form
                    postFormView
                }
            }
            .navigationTitle("Post Ad")
            .navigationBarTitleDisplayMode(.large)
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
    
    // MARK: - Form Validation Helpers
    private var isTitleInvalid: Bool {
        hasAttemptedSubmit && viewModel.title.trimmed.isEmpty
    }
    
    private var isDescriptionInvalid: Bool {
        hasAttemptedSubmit && viewModel.description.trimmed.isEmpty
    }
    
    private var isPriceInvalid: Bool {
        hasAttemptedSubmit && (viewModel.priceText.trimmed.isEmpty || viewModel.price <= 0)
    }
    
    private var isImagesInvalid: Bool {
        hasAttemptedSubmit && viewModel.totalImageCount == 0
    }
    
    // MARK: - Post Form
    private var postFormView: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // MARK: - Image Section
                imageSection
                
                // Inline image validation
                if isImagesInvalid {
                    inlineError("Please add at least one photo.")
                        .padding(.horizontal)
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isTitleInvalid ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if isTitleInvalid {
                        inlineError("Title is required.")
                    }
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
                                .stroke(isDescriptionInvalid ? Color.red : Color(.separator), lineWidth: isDescriptionInvalid ? 1 : 0.5)
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
                    
                    if isDescriptionInvalid {
                        inlineError("Description is required.")
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
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isPriceInvalid ? Color.red : Color.clear, lineWidth: 1)
                        )
                    
                    if isPriceInvalid {
                        inlineError("Please enter a valid price.")
                    }
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
                
                // MARK: - Post Button
                Button {
                    hasAttemptedSubmit = true
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    Task {
                        await viewModel.postItem()
                    }
                } label: {
                    HStack(spacing: 8) {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                        Text("Post Item")
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
        .onTapGesture {
            hideKeyboard()
        }
    }
    
    // MARK: - Inline Error Label
    private func inlineError(_ message: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.caption2)
            Text(message)
                .font(.caption)
        }
        .foregroundStyle(.red)
        .transition(.opacity)
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("Photos", systemImage: "photo.on.rectangle")
                    .font(.caption)
                    .foregroundStyle(isImagesInvalid ? .red : .secondary)
                Spacer()
                Text("\(viewModel.totalImageCount)/\(AppConstants.Validation.maxImages)")
                    .font(.caption2)
                    .foregroundStyle(isImagesInvalid ? .red : .secondary)
            }
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
                            .foregroundStyle(isImagesInvalid ? .red : Color.accentColor)
                            .frame(width: 100, height: 100)
                            .background((isImagesInvalid ? Color.red : Color.accentColor).opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isImagesInvalid ? Color.red : Color.clear, lineWidth: 1)
                            )
                        }
                    }
                    
                    // Selected Images
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
    }
    
    // MARK: - Success View
    private var postSuccessView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green)
            
            Text("Posted Successfully!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your item is now live on the marketplace.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Button {
                hasAttemptedSubmit = false
                viewModel.didPostSuccessfully = false
                Task {
                    await itemViewModel.refresh()
                }
            } label: {
                Text("Post Another Item")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

#Preview {
    PostItemView(itemViewModel: ItemViewModel())
}
