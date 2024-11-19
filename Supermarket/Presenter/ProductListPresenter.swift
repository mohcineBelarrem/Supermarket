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
    
    var isUserLoggedIn: Bool {
        interactor.isUserLoggedIn
    }
    
    init(interactor: ProductListInteractorProtocol, router: ProductListRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.productCategories = self.regroupProductsByCategories(products: interactor.retrieveProducts())
    }
    
    func viewDidLoad() {
        loadProduct()
        subscribeToCartChanges()
    }
    
    func detailView(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView {
        router.routeToDetailView(for: product.id, modelContext: modelContext)
    }
    
    func categoryView(for category: CategoryPresentationModel) -> AnyView {
        router.routeToCategoryView(for: category)
    }
    
    func productView(for product: ProductDetailPresentationModel) -> AnyView {
        router.routeToProductView(for: product)
    }
    
    func cartButton(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView {
        router.routeToCartButton(for: product, modelContext: modelContext)
    }
    
    private func loadProduct() {
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
                return products.map { ProductDetailPresentationModel(product: $0) }
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (products: [ProductDetailPresentationModel]) in
                guard let self else { return }
                self.productCategories = self.regroupProductsByCategories(products: products)
                if self.interactor.retrieveProducts().isEmpty {
                    self.interactor.store(products: products)
                }
            })
            .store(in: &cancellables)
    }
    
    private func subscribeToCartChanges() {
        interactor.notificationPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.loadProduct()
            })
            .store(in: &cancellables)
    }
    
    private func regroupProductsByCategories(products: [ProductDetailPresentationModel]) -> [CategoryPresentationModel] {
        let categories = Dictionary(grouping: products, by: {$0.category})
        return categories.map { (category: String, products: [ProductDetailPresentationModel]) in
            CategoryPresentationModel(id: UUID(),
                                      name: category,
                                      products: products
            )
        }.sorted(by: {$0.name < $1.name})
    }
}
