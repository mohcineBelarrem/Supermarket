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
        VStack {
            if let error = presenter.errorMessage {
                Text("API is down: \(error)")
                    .font(.headline)
                    .foregroundColor(.red)
            } else if let productDetail = presenter.productDetail {
                Text(productDetail.name)
                Text(productDetail.availability)
                Text(productDetail.manufacturer)
                Text(productDetail.formattedPrice)
                Text("\(productDetail.currentStock)")
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear { presenter.loadProductDetail(for: productId) }
    }
}

#Preview {
    let interactor = ProductDetailInteractor()
    let router = ProductDetailRouter()
    let presenter = ProductDetailPresenter(interactor: interactor, router: router)
    
    ProductDetailView(presenter: presenter, productId: 4643)
}
