//
//  ProductListPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import Foundation
import SwiftUI
import Combine

class ProductListPresenter: ObservableObject {
    private let interactor: ProductListInteractorProtocol
    private let router: ProductListRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var productCategories: [CategoryPresentationModel] = []
    @Published var errorMessage: String?
    
    init(interactor: ProductListInteractorProtocol, router: ProductListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchProducts()
            .map { (products : [Product]) in
                let categories = Dictionary(grouping: products, by: {$0.category})
                return categories.map { (category: String, products: [Product]) in
                    CategoryPresentationModel(id: UUID(),
                                              name: category,
                                              products: products.map { ProductPresentationModel(id: $0.id,
                                                                                                name: $0.name,
                                                                                                category: $0.category,
                                                                                                inStock: $0.inStock,
                                                                                                availability: $0.inStock ? "Available" : "Out of Stock")}
                    )
                }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { productCategories in
                self.productCategories = productCategories
            })
            .store(in: &cancellables)
    }
    
    func detailView(for product: ProductPresentationModel) -> AnyView {
        router.routeToDetailView(for: product)
    }
    
    func productView(for product: ProductPresentationModel) -> AnyView {
        router.routeToProductView(for: product)
    }
}
