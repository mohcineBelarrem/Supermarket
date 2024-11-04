//
//  CartErrors.swift
//  Supermarket
//
//  Created by Mohcine on 4/11/2024.
//

enum AddToCartError: Error {
    case cartNotFound
}

enum DeleteProductError: Error {
    case cartNotFound
    case productNotFound
    case badServerResponse
}
