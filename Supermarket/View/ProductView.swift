//
//  ProductView.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI

struct ProductView: View {
    var product: ProductDetailPresentationModel
    var body: some View {
        HStack() {
            Text(product.name)
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.leading)
            Spacer()
            Text(product.price.formattedPrice)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(product.inStock ? .green : .red)
        }
    }
}

#Preview {
    ProductView(product: ProductDetailPresentationModel.dummyProduct)
}
