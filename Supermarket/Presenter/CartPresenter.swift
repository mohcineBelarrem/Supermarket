//
//  CartPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation
import SwiftUI
import Combine

protocol CartPresenterProtocol: ObservableObject {
    var cart: CartPresentationModel? { get }
    var errorMessage: String? { get }
    var isUserLoggedIn: Bool { get }
    func loadCart()
    func goToLogin()
    func goToProductList()
}

class CartPresenter: ObservableObject, CartPresenterProtocol {
    private let interactor: CartInteractorProtocol
    private let router: CartRouterProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var cart: CartPresentationModel?
    @Published var errorMessage: String?
    
    var isUserLoggedIn: Bool {
        interactor.isUserLoggedIn
    }

    init(interactor: CartInteractorProtocol, router: CartRouter) {
        self.interactor = interactor
        self.router = router
    }

    func loadCart() {
        interactor.fetchCart()
            .flatMap { [weak self] cart -> AnyPublisher<Cart?, Error> in
                if let cart = cart {
                    return Just(cart)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return self?.interactor.createCart() ?? Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
                }
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Error fetching cart: \(error.localizedDescription)"
                }
            }, receiveValue: { cart in
                if let cart = cart {
                    self.interactor.storeCartId(with: cart.cartId)
                    self.cart = CartPresentationModel(cart)
                }
            })
            .store(in: &cancellables)
    }
    
    func goToLogin() {
        router.goToLogin()
    }
    
    func goToProductList() {
        router.goToProductList()
    }
}
