//
//  OrderItem.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//

struct OrderItem: Decodable {
    let orderId: String
    let items: [CartItem]
    let created: String
    
    private enum CodingKeys: String, CodingKey {
        case orderId = "id"
        case items, created
    }
}
