//
//  CartItem.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation

struct Cart {
    let cartId: String
    let items: [CartItem]
}

struct CartItem: Decodable {
    let id: Int
    let productId: Int
    let quantity: Int
}
