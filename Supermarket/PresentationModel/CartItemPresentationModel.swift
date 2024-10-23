//
//  CartItemPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation

struct CartPresentationModel: Codable {
    let cartId: String
    let items: [CartItemPresentationModel]
    
    var isEmpty: Bool { items.isEmpty }
    
    init (_ cart: Cart) {
        self.cartId = cart.cartId
        self.items = cart.items.map { .init($0) }
    }
}

struct CartItemPresentationModel: Identifiable, Codable {
    let id: Int
    let productId: Int
    let quantity: Int
    
    init(_ cartItem: CartItem) {
        self.id = cartItem.id
        self.productId = cartItem.productId
        self.quantity = cartItem.quantity
    }
}
