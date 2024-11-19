//
//  ProductDetailView.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI
import SwiftData

struct ProductDetailView: View {
    @StateObject var presenter: ProductDetailPresenter
    var productId: Int
    @Environment(\.modelContext) private var modelContext

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
                        Text(productDetail.price.formattedPrice)
                        Text("\(productDetail.currentStock)")
                    }
                    Spacer()
                    if presenter.isUserLoggedIn {
                        presenter.addToCartButton(for: productDetail,
                                                  modelContext: modelContext)
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
    let mockModelContainer = try! ModelContainer(for: UserPresentationModel.self)
    ProductDetailRouter.createModule(with: 4643,
                                     modelContext: mockModelContainer.mainContext)
}
