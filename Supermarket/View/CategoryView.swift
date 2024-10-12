//
//  CategoryView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI

struct CategoryView: View {
    var category: CategoryPresentationModel
    var body: some View {
        Section(header: Text(category.name)) {
            ForEach(category.products) { product in
                ProductView(product: product)
            }
        }
    }
}

#Preview {
    CategoryView(category: .init(id: UUID(), name: "Coffee", products: [.init(id: 1, name: "Arabica", category: "Coffee", inStock: true, availability: "Kayn"),.init(id: 2, name: "Robusta", category: "Coffee", inStock: false, availability: "Ma Kaynch")]))
}
