//
//  CartItem.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation

//typealias Cart = [CartItem]

struct CartItem: Decodable {
    let id: Int
    let productId: Int
    let quantity: Int
}

enum CartError: Error {
    case noCartId
}
