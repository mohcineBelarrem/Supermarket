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
    let formattedPrice: String
    let currentStock: Int
    let manufacturer: String
    
    var product: ProductPresentationModel {
        .init(id: id, name: name, category: category, inStock: inStock)
    }
}
