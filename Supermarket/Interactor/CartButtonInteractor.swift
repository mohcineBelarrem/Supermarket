//
//  CartButtonInteractorProtocol.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Combine
import Foundation

protocol CartButtonInteractorProtocol {
    func fetchCart() -> AnyPublisher<Cart?, Error>
}

class CartButtonInteractor: CartButtonInteractorProtocol {
    //private var cartDefaults = UserDefaultsPublisher<CartPresentationModel>(userDefaults: .standard, key: "cart")
    
    private let cartInteractor: CartInteractorProtocol
    
    
    init(cartInteractor: CartInteractorProtocol) {
        self.cartInteractor = cartInteractor
    }
    
    func fetchCart() -> AnyPublisher<Cart?, Error> {
        cartInteractor.fetchCart()
    }
    
}
