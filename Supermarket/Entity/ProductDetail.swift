//
//  ProductDetail.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Foundation

struct ProductDetail: Decodable {
    let id: Int
    let name: String
    let category: String
    let manufacturer: String
    let price: Double
    let currentStock: Int
    let inStock: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id, name, category, manufacturer, price, inStock
        case currentStock = "current-stock"
    }
}
