//
//  ClothingItem.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import Foundation
import FirebaseFirestore

struct ClothingItem: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var name: String
    var category: ClothingCategory
    var brand: String
    var imagePath: String
    var createdAt: Date
    
    init(id: String = UUID().uuidString, name: String, category: ClothingCategory, brand: String, imagePath: String, createdAt: Date = Date()) {
        self.id = id
        self.name = name
        self.category = category
        self.brand = brand
        self.imagePath = imagePath
        self.createdAt = createdAt
    }
    
    var firestoreData: [String: Any] {
        [
            "name": name,
            "category": category.rawValue,
            "brand": brand,
            "imagePath": imagePath,
            "createdAt": createdAt
        ]
    }
}
