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
    var cart: [CartItemPresentationModel]? { get }
    var errorMessage: String? { get }
    var isUserLoggedIn: Bool { get }
    func loadCart()
}

class CartPresenter: ObservableObject, CartPresenterProtocol {
    private let interactor: CartInteractorProtocol
    private let router: CartRouterProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var cart: [CartItemPresentationModel]?
    @Published var errorMessage: String?
    
    var isUserLoggedIn: Bool {
        interactor.isUserLoggedIn
    }

    init(interactor: CartInteractorProtocol, router: CartRouter) {
        self.interactor = interactor
        self.router = router
    }

    func loadCart() {
        if let cartId = interactor.getStoredCartId() {
            interactor.fetchCart(with: cartId)
                .sink { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = "Cart Loading failed: \(error.localizedDescription)"
                    }
                } receiveValue: { cartItemArray in
                    self.cart = cartItemArray.map { .init(id: $0.id, productId: $0.productId, quantity: $0.quantity) }
                }
                .store(in: &cancellables)
        } else {
            interactor.createCart()
                .sink { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = "Cart CreationFailed failed: \(error.localizedDescription)"
                    }
                } receiveValue: { cartCreationResponse in
                    if cartCreationResponse.created {
                        self.interactor.storeCartId(with: cartCreationResponse.cartId)
                        self.cart = []
                    }
                }
                .store(in: &cancellables)
        }
    }
}


//        interactor.fetchCart()
//            .flatMap { [weak self] cart -> AnyPublisher<Cart, Error> in
//                if let cart = cart {
//                    return Just(cart)
//                        .setFailureType(to: Error.self)
//                        .eraseToAnyPublisher()
//                } else {
//                    return self?.interactor.createCart() ?? Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
//                }
//            }
//            .sink(receiveCompletion: { completion in
//                if case .failure(let error) = completion {
//                    self.errorMessage = "Error fetching cart: \(error.localizedDescription)"
//                }
//            }, receiveValue: { cart in
//                self.cart = cart
//            })
//            .store(in: &cancellables)
