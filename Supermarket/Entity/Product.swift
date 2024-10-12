//
//  Product.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let name: String
    let category: String
    let inStock: Bool
}


