//
//  CartButtonInteractorProtocol.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Combine
import Foundation

protocol CartButtonInteractorProtocol {
    func listenToCartForProduct(withId produtId: Int)
    var productQuantityInCartPublisher: Published<Int?>.Publisher { get }
}

class CartButtonInteractor: CartButtonInteractorProtocol {
    private var cartDefaults = UserDefaultsPublisher<CartPresentationModel>(userDefaults: .standard, key: "cart")
    
    @Published var productQuantityInCart: Int?
    private var cancellables = Set<AnyCancellable>()
    
    
    var productQuantityInCartPublisher: Published<Int?>.Publisher {
      $productQuantityInCart
    }
    
    init() { }
    
    func listenToCartForProduct(withId produtId: Int) {
        cartDefaults.publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cart in
            guard let self = self else { return }
                self.productQuantityInCart =  cart?.items.filter { $0.productId == produtId }.first?.quantity
            }
            .store(in: &cancellables)
        }
    }
