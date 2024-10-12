//
//  ProductDetailPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Foundation

struct ProductDetailPresentationModel: Identifiable {
    let id: Int
    let name: String
    let category: String
    let inStock: Bool
    let availability: String
    let formattedPrice: String
    let currentStock: Int
    let manufacturer: String
}
