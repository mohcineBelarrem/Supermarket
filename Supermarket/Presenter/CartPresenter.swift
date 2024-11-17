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
    func viewDidLoad()
    func goToLogin()
    func goToProductList()
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
    
    func viewDidLoad() {
        loadCart()
        subscribeToCartChanges()
    }
    
    private func subscribeToCartChanges() {
        interactor.notificationPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self else { return }
                self.loadCart()
            })
            .store(in: &cancellables)
    }
    
    private func loadCart() {
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
