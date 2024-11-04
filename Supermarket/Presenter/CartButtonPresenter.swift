//
//  CartButtonPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation
import Combine
import SwiftUI

protocol CartButtonPresenterProtocol: ObservableObject {
    var productQuantityInCart: Int? { get }
    func fetchQuantity(for product: ProductDetailPresentationModel)
}


class CartButtonPresenter: CartButtonPresenterProtocol {
    private let interactor: CartButtonInteractorProtocol
    private let router: CartButtonRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    private var product: ProductDetailPresentationModel?
    
    @Published var errorMessage: String?
    @Published var productQuantityInCart: Int?
    @Published var isLoading: Bool = false
    @Published var isShowingAddToCartView: Bool = false {
        didSet {
            if let product {
                fetchQuantity(for: product)
            }
        }
    }
    
    init(interactor: CartButtonInteractorProtocol, router: CartButtonRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func isButtonEnabled(for product: ProductDetailPresentationModel) -> Bool {
         product.inStock
    }
    
    func fetchQuantity(for product: ProductDetailPresentationModel) {
        isLoading = true
        self.product = product
        interactor.fetchCart()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] cart in
                guard let self else { return }
                self.isLoading = false
                self.productQuantityInCart = cart?.items.filter { $0.productId == product.id }.first?.quantity
            }
            .store(in: &cancellables)

    }
}
