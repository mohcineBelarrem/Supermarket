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
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var products: [ProductPresentationModel] = []
    @Published var errorMessage: String?
    
    init(interactor: ProductListInteractorProtocol, router: ProductListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchProducts()
            .map { (products : [Product]) in
                products.map { product in
                    ProductPresentationModel(id: product.id,
                                              name: product.name,
                                              category: product.category,
                                              inStock: product.inStock,
                                              availability: product.inStock ? "Available" : "Out of Stock")
                }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { products in
                self.products = products
            })
            .store(in: &cancellables)
    }
}
