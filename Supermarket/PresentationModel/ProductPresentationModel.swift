//
//  ProductPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

struct ProductPresentationModel: Identifiable {
    let id: Int
    let name: String
    let category: String
    let inStock: Bool
    
    static var dummyProduct: Self {
        .init(id: 1, name: "Dummy Product", category: "Dummy Category", inStock: true)
    }
}
