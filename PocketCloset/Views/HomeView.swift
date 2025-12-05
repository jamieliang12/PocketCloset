//
//  HomeView.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import SwiftUI

struct HomeView: View {
    @State private var closetVM: ClosetViewModel
    @State private var outfitVM = OutfitBuilderViewModel()
    
    init(userId: String) { // initializes closetVM user user's ID
        _closetVM = State(initialValue: ClosetViewModel(userId: userId))
    }
    
    var body: some View {
        TabView {
            ClosetView(viewModel: closetVM)
                .tabItem {
                    Label("Closet", systemImage: "cabinet")
                }
            
            OutfitBuilderView(viewModel: outfitVM)
                .tabItem {
                    Label("Outfits", systemImage: "figure.stand")
                }
        }
        .task {
            await closetVM.loadItems()
            outfitVM.setItems(closetVM.items)
        }
        .onChange(of: closetVM.items) { // when closet items change, outfit builder also changes so it always uses the current items
            outfitVM.setItems(closetVM.items)
        }
    }
}

#Preview {
    HomeView(userId: "1")
}
