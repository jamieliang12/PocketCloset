//
//  ClothingCategory.swift
//  PocketCloset
//
//  Created by jamie liang on 12/2/25.
//

import Foundation

enum ClothingCategory: String, CaseIterable, Codable, Identifiable {
    case shortSleeve
    case longSleeve
    case pants
    case shorts
    case skirt
    case shoes
    case outerwear
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .shortSleeve: return "Short Sleeve"
        case .longSleeve: return "Long Sleeve"
        case .pants: return "Pants"
        case .shorts: return "Shorts"
        case .skirt: return "Skirt"
        case .shoes: return "Shoes"
        case .outerwear: return "Outerwear"
        }
    }
}
