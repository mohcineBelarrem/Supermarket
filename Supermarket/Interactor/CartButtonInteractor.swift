//
//  CartButtonInteractorProtocol.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Combine
import Foundation

protocol CartButtonInteractorProtocol {
    func fetchProductQuantity(with productId: Int) -> AnyPublisher<Int?, Error>
}

class CartButtonInteractor: CartButtonInteractorProtocol {
    private let cartInteractor: CartInteractorProtocol
    
    init(cartInteractor: CartInteractorProtocol) {
        self.cartInteractor = cartInteractor
    }
    
    func fetchProductQuantity(with productId: Int) -> AnyPublisher<Int?, any Error> {
        return cartInteractor.fetchCart()
            .map { (cart: Cart?) in
                return cart?.items.filter { $0.productId == productId }.first?.quantity ?? 0
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
