//
//  CategoryPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Foundation

struct CategoryPresentationModel: Identifiable {
    let id: UUID
    let name: String
    let products: [ProductDetailPresentationModel]
}
