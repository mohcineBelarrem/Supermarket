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
                
                VStack(alignment: .leading) {
                    HStack() {
                        Text("Name:")
                        Spacer()
                        Text(productDetail.name)
                    }
                    Divider()
                    
                    HStack() {
                        Text("Manufacturer:")
                        Spacer()
                        Text(productDetail.manufacturer)
                    }
                    Divider()
                    
                    HStack() {
                        Text("Category:")
                        Spacer()
                        Text(productDetail.category)
                    }
                    Divider()
                    
                    HStack() {
                        Text("Price:")
                        Spacer()
                        Text(productDetail.price.formattedPrice)
                    }
                    Divider()
                    
                    HStack() {
                        Text("Available Quantity:")
                        Spacer()
                        Text("\(productDetail.currentStock)")
                    }
                    Divider()
                    
                    if presenter.isUserLoggedIn {
                        HStack() {
                            Spacer()
                            presenter.addToCartButton(for: productDetail,
                                                      modelContext: modelContext)
                            Spacer()
                        }
                        .padding()
                    }
                }
                .padding()
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
