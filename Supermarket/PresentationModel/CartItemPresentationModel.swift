//
//  CartItemPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation
import SwiftData

@Model
class CartPresentationModel {
    var cartId: String
    var items: [CartItemPresentationModel]
    
    init(cartId: String, items: [CartItemPresentationModel]) {
        self.cartId = cartId
        self.items = items
    }
    
    func contains(productId: Int) -> Bool {
        return items.contains(where: { $0.productId == productId })
    }
}

@Model
class CartItemPresentationModel: Identifiable {
    var id: Int
    var productId: Int
    var quantity: Int
    var product: ProductDetailPresentationModel
    
    init(id: Int, productId: Int, quantity: Int, product: ProductDetailPresentationModel) {
        self.id = id
        self.productId = productId
        self.quantity = quantity
        self.product = product
    }
    
    var totalPrice: Double {
        Double(quantity) * product.price
    }
    
    var totalFormattedPrice: String {
        return totalPrice.formattedPrice
    }
    
    var detailledPrice: String {
        return "(\(quantity) x \(product.price.formattedPrice))"
    }
    
}
