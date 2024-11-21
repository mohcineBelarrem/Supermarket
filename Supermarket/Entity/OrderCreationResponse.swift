//
//  OrderCreationResponse.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//

import Foundation

struct OrderCreationResponse: Decodable {
    let created: Bool
    let orderId: String
}
