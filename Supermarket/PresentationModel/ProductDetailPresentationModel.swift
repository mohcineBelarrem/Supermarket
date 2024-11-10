//
//  ProductDetailPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Foundation
import SwiftData

@Model
class ProductDetailPresentationModel {
    var id: Int
    var name: String
    var category: String
    var inStock: Bool
    var price: Double
    var currentStock: Int
    var manufacturer: String
    
    init(id: Int, name: String, category: String, inStock: Bool, price: Double, currentStock: Int, manufacturer: String) {
        self.id = id
        self.name = name
        self.category = category
        self.inStock = inStock
        self.price = price
        self.currentStock = currentStock
        self.manufacturer = manufacturer
    }
    
     init (product: ProductDetail) {
        self.id = product.id
        self.name = product.name
        self.category = product.category
        self.inStock = product.inStock
        self.price = product.price
        self.currentStock = product.currentStock
        self.manufacturer = product.manufacturer
    }
    
    static var dummyProduct: ProductDetailPresentationModel {
        ProductDetailPresentationModel(id: 1, name: "L'or Capsules", category: "Coffee", inStock: true, price: 45.09, currentStock: 10, manufacturer: "L'or Inc")
    }
}
