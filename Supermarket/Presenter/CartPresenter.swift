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
    var cartItems: [CartItemPresentationModel] { get }
    
    var errorMessage: String? { get }
    var isUserLoggedIn: Bool { get }
    func loadCart()
    func goToLogin()
    func goToProductList()
    func deleteCartItem(with cartItemId: Int)
}

class CartPresenter: CartPresenterProtocol {
    private let interactor: CartInteractorProtocol
    private let router: CartRouterProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var cart: CartPresentationModel?
    @Published var errorMessage: String?
   
    @Published var alertMessage: String = ""
    @Published var showAlert: Bool = false
    
    @Published var cartItems: [CartItemPresentationModel] = []
    
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
                guard let self else { return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher() }
                if let cart = cart {
                    return Just(cart)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return self.interactor.createCart()
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    self.errorMessage = "Error fetching cart: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] rawCart in
                guard let self else { return }
                if let rawCart = rawCart, let cart = self.transform(rawCart) {
                    self.cart = cart
                    self.cartItems = cart.items
                    self.interactor.saveCart(cart)
                }
            })
            .store(in: &cancellables)
    }
    
    func deleteCartItem(with cartItemId: Int) {
        self.alertMessage = ""
        self.showAlert = false
        interactor.deleteItemFromCart(with: cartItemId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    self.alertMessage = "error deleting product \(error.localizedDescription)"
                    self.showAlert = true
                }
            }, receiveValue: { [weak self] success in
                guard let self else { return }
                if success {
                    self.loadCart()
                } else {
                    self.alertMessage = "Oops there was an error deleting the product"
                    self.showAlert = true
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


//TODO: Make this the interactor's job
extension CartPresenter {
    private func transform(_ cart: Cart) -> CartPresentationModel? {
        let productList = interactor.retrieveProducts()
        
        guard productList.count > 0 else { return nil }
        
        let items: [CartItemPresentationModel] = cart.items.compactMap { (item: CartItem)  in
            guard let correpsondingProduct = productList.first(where: { $0.id == item.productId }) else { return nil }
            return  .init(id: item.id, productId: item.productId, quantity: item.quantity, product: correpsondingProduct)
        }
        
        guard items.count == cart.items.count else { return nil }
        
        return .init(cartId: cart.cartId, items: items)
    }
}
