//
//  OutfitBuilderView.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import SwiftUI

struct OutfitBuilderView: View {
    @Bindable var viewModel: OutfitBuilderViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // empty state, when no items are in the closet
                if viewModel.allItems.isEmpty {
                    VStack {
                        Text("No items in your closet yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("Add clothes to your closet to start building outfits")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    VStack {
                        // top section
                        HStack {
                            Button {
                                viewModel.previousTop()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            
                            if let top = viewModel.currentOutfit.top {
                                ClothingItemCard(item: top)
                                    .frame(width: 150, height: 200)
                            } else {
                                Text("No top available")
                            }
                            
                            Button {
                                viewModel.nextTop()
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        // bottom section
                        HStack {
                            Button {
                                viewModel.previousBottom()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            
                            if let bottom = viewModel.currentOutfit.bottom {
                                ClothingItemCard(item: bottom)
                                    .frame(width: 150, height: 200)
                            } else {
                                Text("No bottom available")
                            }
                            
                            Button {
                                viewModel.nextBottom()
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                        
                        // shoes section
                        HStack {
                            Button {
                                viewModel.previousShoes()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            
                            if let shoes = viewModel.currentOutfit.shoes {
                                ClothingItemCard(item: shoes)
                                    .frame(width: 150, height: 200)
                            } else {
                                Text("No shoes available")
                            }
                            
                            Button {
                                viewModel.nextShoes()
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.app)
                }
            }
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Outfit Builder")
                        .font(.custom("Noteworthy-Bold", size: 35))
                }
            }
        }
    }
}

#Preview {
    let vm = OutfitBuilderViewModel()
        vm.setItems([
            ClothingItem(
                id: "1",
                name: "Black Hoodie",
                category: .longSleeve,
                brand: "Nike",
                imagePath: "clothingImages/preview/hoodie.jpg",
                createdAt: Date()
            ),
            ClothingItem(
                id: "2",
                name: "Blue Jeans",
                category: .pants,
                brand: "Levi's",
                imagePath: "clothingImages/preview/jeans.jpg",
                createdAt: Date()
            ),
            ClothingItem(
                id: "3",
                name: "White Sneakers",
                category: .shoes,
                brand: "New Balance",
                imagePath: "clothingImages/preview/sneakers.jpg",
                createdAt: Date()
            )
        ])
        
        return OutfitBuilderView(viewModel: vm)
}
