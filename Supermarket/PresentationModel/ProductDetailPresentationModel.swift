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
    
    static var dummyProduct: Self {
        .init(id: 1, name: "L'or Capsules", category: "Coffee", inStock: true, price: 45.09, currentStock: 10, manufacturer: "L'or Inc")
    }
}

extension ProductDetailPresentationModel {
    init (product: ProductDetail) {
        self.id = product.id
        self.name = product.name
        self.category = product.category
        self.inStock = product.inStock
        self.price = product.price
        self.currentStock = product.currentStock
        self.manufacturer = product.manufacturer
    }
}
