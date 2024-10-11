//
//  ProductListPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import Combine

class ProductListPresenter: ObservableObject {
    private let interactor: ProductListInteractorProtocol
    private let router: ProductListRouterProtocol
    
    @Published var products: [Product] = []
    
    init(interactor: ProductListInteractorProtocol, router: ProductListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        products = interactor.fetchProducts()
    }
}
