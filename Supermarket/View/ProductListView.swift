//
//  ProductListView.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI

struct ProductListView: View {
    @ObservedObject var presenter: ProductListPresenter
    
    var body: some View {
        NavigationView {
            if let error = presenter.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else if presenter.productCategories.isEmpty {
                ProgressView("Loading...")
            } else {
                List {
                    ForEach(presenter.productCategories) { category in
                        Section(header: Text(category.name)) {
                            ForEach(category.products) { product in
                               NavigationLink {
                                    presenter.detailView(for: product.id)
                                } label: {
                                    ProductView(product: product) //TODO: Fix me
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            if presenter.productCategories.isEmpty {
                presenter.viewDidLoad()
            }
        }
    }
}

#Preview {
    let interactor = ProductListInteractor()
    let router = ProductListRouter()
    let presenter = ProductListPresenter(interactor: interactor, router: router)
    
    ProductListView(presenter: presenter)
}
