//
//  ProductView.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI

struct ProductView: View {
    var product: ProductPresentationModel
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.name)
                .font(.headline)
            Text(product.category)
                .font(.subheadline)
            Text(product.availability)
                .foregroundColor(product.inStock ? .green : .red)
        }
    }
}

#Preview {
    ProductView(product: .init(id: 1, name: "Banana", category: "Fruits", inStock: true, availability: "Available"))
}
