//
//  ProductListInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import Foundation

protocol ProductListInteractorProtocol {
    func fetchProducts() -> [Product]
}

class ProductListInteractor: ProductListInteractorProtocol {
    func fetchProducts() -> [Product] {
        return [
                .init(id: UUID(), name: "Apples", category: "Fruits", inStock: true),
                .init(id: UUID(), name: "Columbia 100% Arabica", category: "Coffee", inStock: true),
        ]
    }
}
