//
//  ClosetView.swift
//  PocketCloset
//
//  Created by jamie liang on 12/1/25.
//

import SwiftUI

struct ClosetView: View {
    @Bindable var viewModel: ClosetViewModel
    @State private var sheetIsPresented = false
    @State private var itemToEdit: ClothingItem?
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading closet...")
                } else if viewModel.items.isEmpty {
                    Text("No items in your closet yet. Add your first item!")
                        .foregroundStyle(.secondary)
                } else {
                    ScrollView {
                        // flexible grid to display clothing items in closet
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 24) {
                            ForEach(viewModel.items) { item in
                                ZStack(alignment: .topTrailing) {
                                    // tapping on the card opens the edit sheet
                                    Button {
                                        itemToEdit = item
                                    } label: {
                                        ClothingItemCard(item: item)
                                    }
                                    
                                    // delete button on top right of card
                                    Button {
                                        Task {
                                            await viewModel.deleteItem(item)
                                        }
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title3)
                                            .frame(width: 26, height: 26)
                                            .foregroundStyle(.red)
                                            .padding(8)
                                    }
                                    .offset(x: 7)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Closet")
                        .font(.custom("Noteworthy-Bold", size: 40))
                        .padding(.top, 8)
                }
            }
            .toolbar {
                // add new clothing item button
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sheetIsPresented = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.app)
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented) {
                AddItemView(userId: viewModel.userId)
            }
            .sheet(item: $itemToEdit) { item in
                AddItemView(userId: viewModel.userId, itemToEdit: item)
            }
            // reloads closet after done with adding/editing clothing item
            .onChange(of: sheetIsPresented) {
                if sheetIsPresented == false {
                    Task {
                        await viewModel.loadItems()
                    }
                }
            }
            .onChange(of: itemToEdit) {
                if itemToEdit == nil {
                    Task {
                        await viewModel.loadItems()
                    }
                }
            }
        }
    }
}

#Preview {
    let vm = ClosetViewModel(userId: "test")
    vm.items = [
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
                    name: "Flip Flops",
                    category: .shoes,
                    brand: "Guess",
                    imagePath: "clothingImages/preview/shoes.jpg",
                    createdAt: Date()
                )
    ]
    return ClosetView(viewModel: vm)
}
