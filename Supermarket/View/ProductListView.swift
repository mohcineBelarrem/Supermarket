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
                        CategoryView(category: category)
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
