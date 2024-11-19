//
//  CategoryView.swift
//  Supermarket
//
//  Created by Mohcine on 18/11/2024.
//

import SwiftUI

struct CategoryView: View {
    var category: CategoryPresentationModel
    var body: some View {
        HStack() {
            Text(category.name.uppercased())
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProductView(product: ProductDetailPresentationModel.dummyProduct)
}
