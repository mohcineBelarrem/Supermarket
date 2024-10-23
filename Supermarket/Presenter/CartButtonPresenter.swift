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
    func subscribeForQuantity(for product: ProductDetailPresentationModel)
    func isButtonEnabled(for product: ProductDetailPresentationModel) -> Bool
}


class CartButtonPresenter: CartButtonPresenterProtocol {
    private let interactor: CartButtonInteractorProtocol
    private let router: CartButtonRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var productQuantityInCart: Int?
    
    init(interactor: CartButtonInteractorProtocol, router: CartButtonRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func isButtonEnabled(for product: ProductDetailPresentationModel) -> Bool {
         product.inStock
    }
    
    func subscribeForQuantity(for product: ProductDetailPresentationModel) {
        
//        if !isSubscribed {
            interactor.listenToCartForProduct(withId: product.id)
            
            interactor.productQuantityInCartPublisher
                .receive(on: DispatchQueue.main)
                .assign(to: \.productQuantityInCart, on: self)
                .store(in: &cancellables)
            
//            isSubscribed = true
//        }
    }
}
