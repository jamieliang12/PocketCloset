//
//  OutfitBuilderViewModel.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable

class OutfitBuilderViewModel {
    var allItems: [ClothingItem] = []
    var currentOutfit = Outfit()
    var topIndex = 0 // index tracker to cycle through tops, bottom, shoes
    var bottomIndex = 0
    var shoesIndex = 0
    
    private func items(for category: ClothingCategory) -> [ClothingItem] { // returns only the items matching the specific clothing category
        allItems.filter { $0.category == category }
    }
    
    private func resetToFirst() { // loads the first generated outfit with the first available top, bottom, and shoes
        let tops = items(for: .shortSleeve) + items(for: .longSleeve) + items(for: .outerwear)
        let bottoms = items(for: .pants) + items(for: .shorts) + items(for: .skirt)
        let shoes = items(for: .shoes)
        
        currentOutfit.top = tops.first
        currentOutfit.bottom = bottoms.first
        currentOutfit.shoes = shoes.first
        
        topIndex = 0
        bottomIndex = 0
        shoesIndex = 0
    }
    
    func setItems(_ items: [ClothingItem]) { // use whenever closet updates
        self.allItems = items
        resetToFirst()
    }
    
    
    // Next Item Functions, cycle going forward in the clothing collection
    func nextTop() {
        let tops = items(for: .shortSleeve) + items(for: .longSleeve) + items(for: .outerwear)
        guard !tops.isEmpty else { return }
        topIndex = (topIndex + 1) % tops.count // increase index by 1 to go to next index, modulo divide if on last index to go back to index 0
        currentOutfit.top = tops[topIndex]
    }
    
    func nextBottom() {
        let bottoms = items(for: .pants) + items(for: .shorts) + items(for: .skirt)
        guard !bottoms.isEmpty else { return }
        bottomIndex = (bottomIndex + 1) % bottoms.count
        currentOutfit.bottom = bottoms[bottomIndex]
    }
    
    func nextShoes() {
        let shoes = items(for: .shoes)
        guard !shoes.isEmpty else { return }
        shoesIndex = (shoesIndex + 1) % shoes.count
        currentOutfit.shoes = shoes[shoesIndex]
    }
    // Previous Item Functions, cycle backward through the clothing collection
    func previousTop() {
        let tops = items(for: .shortSleeve) + items(for: .longSleeve) + items(for: .outerwear)
        guard !tops.isEmpty else { return }
        topIndex = (topIndex - 1 + tops.count) % tops.count
        currentOutfit.top = tops[topIndex]
    }
    
    func previousBottom() {
        let bottoms = items(for: .pants) + items(for: .shorts) + items(for: .skirt)
        guard !bottoms.isEmpty else { return }
        bottomIndex = (bottomIndex - 1 + bottoms.count) % bottoms.count
        currentOutfit.bottom = bottoms[bottomIndex]
    }
    
    func previousShoes() {
        let shoes = items(for: .shoes)
        guard !shoes.isEmpty else { return }
        shoesIndex = (shoesIndex - 1 + shoes.count) % shoes.count
        currentOutfit.shoes = shoes[shoesIndex]
    }
}
