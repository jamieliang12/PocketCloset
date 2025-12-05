//
//  ClothingItemCard.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import SwiftUI
import FirebaseStorage

struct ClothingItemCard: View {
    let item: ClothingItem
    @State private var downloadURL: URL?
    @State private var isLoading = true
    var body: some View {
        VStack(spacing: 8) {
            Group {
                if let url = downloadURL {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .tint(.red)
                                .scaleEffect(4)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 120)
                                .foregroundStyle(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
            }
            .frame(height: 120)
            .frame(maxWidth: .infinity)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // text info on clothing item
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(item.brand)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .frame(width: 150, height: 200)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemBackground)).shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3))
        .task(id: item.imagePath) {
            downloadURL = nil
            await loadImageURL()
        }
    }
    
    func loadImageURL() async {
        let storage = Storage.storage()
        let ref = storage.reference(withPath: item.imagePath)
        
        do {
            print("🔍 Loading image for path: \(item.imagePath)") // DELETE AFTER TEST
            let url = try await ref.downloadURL()
            self.downloadURL = url
        } catch {
            print("😡 ERROR in loading image URL: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ClothingItemCard(item: ClothingItem(id: "1", name: "Test", category: .longSleeve, brand: "Test", imagePath: "Test", createdAt: Date()))
}
