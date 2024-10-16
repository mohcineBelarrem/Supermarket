//
//  ProductDetailView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI

struct ProductDetailView: View {
    @ObservedObject var presenter: ProductDetailPresenter
    var productId: Int

    var body: some View {
        VStack(alignment: .leading) {
            if let error = presenter.errorMessage {
                Text("API is down: \(error)")
                    .font(.headline)
                    .foregroundColor(.red)
            } else if let productDetail = presenter.productDetail {
                
                Text(productDetail.name)
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(productDetail.manufacturer)
                        Text(productDetail.formattedPrice)
                        Text("\(productDetail.currentStock)")
                    }
                    Spacer()
                    if presenter.isUserLoggedIn {
                        presenter.addToCartView(for: productDetail.product)
                    }
                }
            } else{
                ProgressView("Loading...")
            }
        }
        .padding()
        .onAppear { presenter.loadProductDetail(for: productId) }
    }
}

#Preview {
    ProductDetailRouter.createModule(with: 4643)
}
