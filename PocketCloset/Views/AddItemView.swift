//
//  AddItemView.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: AddItemViewModel
    @State private var pickedItem: PhotosPickerItem?
    @State private var pickerIsPresented: Bool
    @State private var selectedImage: Image? = nil
    @State private var existingImageURL: URL? = nil // used if editing clothing item

    init(userId: String, itemToEdit: ClothingItem? = nil) {
        _viewModel = State(initialValue: AddItemViewModel(userId: userId, existingItem: itemToEdit))
        _pickerIsPresented = State(initialValue: itemToEdit == nil) // automatically opens image picker only when adding a new item for the first time
    }
    
    private var isEditing: Bool {
        viewModel.existingItem != nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Group {
                    if let selectedImage {
                        selectedImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 250)
                    } else if let url = existingImageURL { // loads stored image from Firebase Storage, considers different cases
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .scaleEffect(3)
                                    .foregroundStyle(.red)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 250)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 250)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                    }
                }
                
                Button("Choose Photo") {
                    pickerIsPresented = true
                }
                .padding(.bottom)
                
                Spacer()
                
                Form {
                    Section("Details") {
                        TextField("Name", text: $viewModel.name)
                        
                        CategoryPicker(selectedCategory: $viewModel.selectedCategory)
                        
                        TextField("Brand", text: $viewModel.brand)
                            .textInputAutocapitalization(.words)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Item" : "Add Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(isEditing ? "Update" : "Save") {
                        Task {
                            let success = await viewModel.save()
                            if success {
                                dismiss()
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isSaving)
                }
            }
            .tint(.app)
        }
        .photosPicker(isPresented: $pickerIsPresented, selection: $pickedItem, matching: .images)
        .onChange(of: pickedItem) { oldValue, newValue in
            Task {
                await loadSelectedPhoto()
            }
        }
        .padding()
        .task {
            await loadExistingImageIfNeeded()
        }
    }
    
    private func loadSelectedPhoto() async {
        guard let pickedItem else { return }
        do {
            if let data = try await pickedItem.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) { // convert picker photo result into data, then UIImage, then into SwiftUI Image
                selectedImage = Image(uiImage: uiImage)
                viewModel.image = uiImage
            } else {
                print("ERROR: Could not use selected image")
            }
        } catch {
            print("😡 ERROR: Could not load selected photo \(error.localizedDescription)")
        }
    }
    
    private func loadExistingImageIfNeeded() async {
        guard existingImageURL == nil,
              let item = viewModel.existingItem else { return }
        
        let storage = Storage.storage()
        let ref = storage.reference(withPath: item.imagePath)
        
        do {
            let url = try await ref.downloadURL()
            existingImageURL = url
        } catch {
            print("ERROR loading existing image URL: \(error.localizedDescription)")
        }
    }
}

#Preview {
    AddItemView(userId: "test")
}
