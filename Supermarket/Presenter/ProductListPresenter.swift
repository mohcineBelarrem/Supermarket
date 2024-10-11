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
    
    @Published var products: [Product] = []
    @Published var errorMessage: String?
    
    init(interactor: ProductListInteractorProtocol, router: ProductListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchProducts()
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
