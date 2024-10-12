//
//  ProductDetailPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Foundation
import Combine

class ProductDetailPresenter: ObservableObject {
    private let interactor: ProductDetailInteractorProtocol
    private let router: ProductDetailRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var productDetail: ProductDetailPresentationModel?
    @Published var errorMessage: String?
    
    init(interactor: ProductDetailInteractorProtocol, router: ProductDetailRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func loadProductDetail(for productId: Int) {
        interactor.getProductDetail(for: productId)
            .map {  ProductDetailPresentationModel(id: $0.id,
                                                   name: $0.name,
                                                   category: $0.category,
                                                   inStock: $0.inStock,
                                                   availability:  $0.inStock ? "Available" : "Out of Stock",
                                                   formattedPrice: "$\($0.price)",
                                                   currentStock: $0.currentStock,
                                                   manufacturer: $0.manufacturer)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { productDetail in
                self.productDetail = productDetail
            })
            .store(in: &cancellables)
    }
}
