//
//  ProductListPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import Foundation
import SwiftUI
import SwiftData
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
            .flatMap { (products: [Product]) in
                Publishers.MergeMany(products.map { [weak self] (product : Product) in
                    guard let self else { return Empty<ProductDetail, Error>().eraseToAnyPublisher() }
                    return self.interactor.fetchProductDetail(for: product.id)
                })
            }
            .collect()
            .receive(on: DispatchQueue.main)
            .map { (products : [ProductDetail]) in
                let categories = Dictionary(grouping: products, by: {$0.category})
                return categories.map { (category: String, products: [ProductDetail]) in
                    CategoryPresentationModel(id: UUID(),
                                              name: category,
                                              products: products.map { ProductDetailPresentationModel(product: $0) }
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
                self.productCategories = productCategories.sorted(by: { $0.name < $1.name })
            })
            .store(in: &cancellables)
    }
    
    func detailView(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView {
        router.routeToDetailView(for: product.id, modelContext: modelContext)
    }
    
    func productView(for product: ProductDetailPresentationModel) -> AnyView {
        router.routeToProductView(for: product)
    }
}
