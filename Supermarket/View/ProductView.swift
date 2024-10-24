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
            Text(product.inStock.availability)
                .foregroundColor(product.inStock ? .green : .red)
        }
    }
}

#Preview {
    ProductView(product: ProductPresentationModel.dummyProduct)
}
