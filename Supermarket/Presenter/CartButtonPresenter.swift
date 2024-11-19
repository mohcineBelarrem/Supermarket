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
    private let interactor: CartInteractorProtocol
    private let router: CartButtonRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var productQuantityInCart: Int?
    @Published var isLoading: Bool = false
    @Published var isShowingAddToCartView: Bool = false
    
    private var cart: CartPresentationModel? {
        interactor.retrieveCart()
    }
    
    init(interactor: CartInteractorProtocol, router: CartButtonRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func isButtonEnabled(for product: ProductDetailPresentationModel) -> Bool {
         product.inStock
    }
    
    func fetchQuantity(for product: ProductDetailPresentationModel) {
        self.productQuantityInCart = cart?.items.filter { $0.productId == product.id }.first?.quantity
        interactor.notificationPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.productQuantityInCart = self.cart?.items.filter { $0.productId == product.id }.first?.quantity
            })
            .store(in: &cancellables)
    }
}
