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
            List {
                ForEach(presenter.products) { product in
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .font(.headline)
                        Text(product.category)
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            presenter.viewDidLoad()
        }
    }
}

#Preview {
    let interactor = ProductListInteractor()
    let router = ProductListRouter()
    let presenter = ProductListPresenter(interactor: interactor, router: router)
    
    ProductListView(presenter: presenter)
}