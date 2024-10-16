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
    let price: Double
    let currentStock: Int
    let manufacturer: String
    
    var product: ProductPresentationModel {
        .init(id: id, name: name, category: category, inStock: inStock)
    }
    
    static var dummyProduct: Self {
        .init(id: 1, name: "L'or Capsules", category: "Coffee", inStock: true, price: 45.09, currentStock: 10, manufacturer: "L'or Inc")
    }
}
