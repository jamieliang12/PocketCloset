//
//  ClosetViewModel.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

@MainActor
@Observable

class ClosetViewModel {
    var items: [ClothingItem] = []
    var isLoading = false
    var errorMessage: String?
    
    private let db = Firestore.firestore()
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    private var collectionRef: CollectionReference {
        db.collection("users")
            .document(userId)
            .collection("clothingItems")
    }
    
    func loadItems() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let snapshot = try await collectionRef
                .order(by: "createdAt", descending: true)
                .getDocuments()
            self.items = snapshot.documents.compactMap { doc in
                try? doc.data(as: ClothingItem.self)
            }
        } catch {
            print("😡 Could not get items from document: \(error.localizedDescription)")
        }
        isLoading = false
    }
    
    func deleteItem(_ item: ClothingItem) async {
        guard let id = item.id else {
            print("ERROR: No id on clothing item")
            return
        }
        let storage = Storage.storage()
        let imageRef = storage.reference(withPath: item.imagePath)
        
        do { // delete in storage
            try await imageRef.delete()
            print("Deleted image at path: \(item.imagePath)")
        } catch {
            print("ERROR: Could not delete image: \(error.localizedDescription)")
        }
        do { // delete in database
            try await collectionRef.document(id).delete()
            await loadItems()
        } catch {
            print("😡 ERROR: Could not delete item: \(error.localizedDescription)")
        }
    }
}


