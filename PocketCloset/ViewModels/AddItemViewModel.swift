//
//  AddItemViewModel.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
@Observable

class AddItemViewModel {
    var name: String = ""
    var brand: String = ""
    var selectedCategory: ClothingCategory = .shortSleeve
    var image: UIImage?
    
    var isSaving = false
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    let userId: String
    
    var existingItem: ClothingItem? // to use if editing a clothing item
    
    init(userId: String, existingItem: ClothingItem? = nil) {
        self.userId = userId
        self.existingItem = existingItem
        
        if let item = existingItem { // if clothing item exists/not nil, load in to be able to edit
            self.name = item.name
            self.brand = item.brand
            self.selectedCategory = item.category
        }
    }
    
    private var collectionRef: CollectionReference { // shortcut reference to user's clothingItems
        db.collection("users")
            .document(userId)
            .collection("clothingItems")
    }
    
    func save() async -> Bool { // function saves or updates clothing item
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }
        
        isSaving = true
        
        if let existingItem {
            let result = await update(existingItem)
            isSaving = false
            return result
        } else {
            let result = await createNewItem()
            isSaving = false
            return result
        }
    }
    
    func createNewItem() async -> Bool {
        guard let image = image else {
            return false
        }
        guard let data = image.jpegData(compressionQuality: 0.9) else { // convert UIImage to jpeg data for uploading
            return false
        }
        
        do {
            let docRef = collectionRef.document()
            let itemId = docRef.documentID
            
            let path = "clothingImages/\(userId)/\(itemId).jpg" // creating Firebase Storage path for item
            let storageRef = storage.reference(withPath: path)
            
            _ = try await storageRef.putDataAsync(data) // upload image to storage
            
            let item = ClothingItem(id: itemId, name: name, category: selectedCategory, brand: brand, imagePath: path, createdAt: Date()) // ClothingItem model to store in Firestore
            
            try docRef.setData(from: item)
            return true
        } catch {
            print("ERROR: \(error.localizedDescription)")
            return false
        }
    }
    
    func update(_ item: ClothingItem) async -> Bool { // updates existing item
        guard let id = item.id else {
            print("ERROR: Missing item id")
            return false
        }
        
        let docRef = collectionRef.document(id)
        var imagePath = item.imagePath
        
        do { // if new image chosen when editing item, upload using same storage path
            if let image = image,
               let data = image.jpegData(compressionQuality: 0.9) {
                let storageRef = storage.reference(withPath: imagePath)
                
                _ = try await storageRef.putDataAsync(data)
            }
            
            let updated = ClothingItem(id: id, name: name, category: selectedCategory, brand: brand, imagePath: imagePath, createdAt: item.createdAt) // updated item w/ new values
            try docRef.setData(from: updated)
            return true
        } catch {
            print("\(error.localizedDescription)")
            return false
        }
    }
    
}
