//
//  CategoryPicker.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import SwiftUI

struct CategoryPicker: View {
    @Binding var selectedCategory: ClothingCategory
    
    var body: some View {
        Picker("Category", selection: $selectedCategory) {
            ForEach(ClothingCategory.allCases) { category in
                Text(category.displayName)
                    .tag(category)
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    @Previewable @State var category: ClothingCategory = .shoes
    CategoryPicker(selectedCategory: $category)
}
