//
//  Product.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import Foundation

struct Product: Identifiable {
    let id: UUID
    let name: String
    let category: String
    let inStock: Bool
}


