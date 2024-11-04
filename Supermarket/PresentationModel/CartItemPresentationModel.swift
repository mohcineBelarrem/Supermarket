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
    
    init (_ cart: Cart, _ products: [Product] = []) {
        self.cartId = cart.cartId
        self.items = cart.items.map { (cartItem: CartItem) in
            
            let name = products.filter { $0.id == cartItem.productId }.first?.name
            
            return CartItemPresentationModel(cartItem, name: name)
        } 
    }
}

struct CartItemPresentationModel: Identifiable, Codable {
    let id: Int
    let productId: Int
    let name: String?
    let quantity: Int
    
    init(_ cartItem: CartItem, name: String?) {
        self.id = cartItem.id
        self.productId = cartItem.productId
        self.quantity = cartItem.quantity
        self.name = name
    }
    
    var label: String {
        name ?? "\(productId)"
    }
}
