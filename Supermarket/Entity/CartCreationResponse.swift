//
//  CartCreationResponse.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//


import Foundation

struct CartCreationResponse: Decodable {
    let created: Bool
    let cartId: String
}
