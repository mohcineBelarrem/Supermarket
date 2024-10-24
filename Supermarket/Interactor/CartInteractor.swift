//
//  CartInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation
import Combine

protocol CartInteractorProtocol {
    var isUserLoggedIn: Bool { get }
    func fetchCart() -> AnyPublisher<Cart?, Error>
    func createCart() -> AnyPublisher<Cart?, Error>
    func addProductToCart(_ product: ProductPresentationModel, with quantity: Int) -> AnyPublisher<AddToCartResponse, Error>
    func storeCartId(with cartId: String)
    func getStoredCartId() -> String?
    func addItemToCart(with itemId: Int, productId: Int, quantity: Int)
}

class CartInteractor: CartInteractorProtocol {
    private var cartDefaults = UserDefaultsPublisher<CartPresentationModel>(userDefaults: .standard, key: "cart")
    private let loginInteractor: LoginInteractorProtocol
    
    @Published var cart: CartPresentationModel?
    private var cancellables = Set<AnyCancellable>()
    
    var isUserLoggedIn: Bool {
        loginInteractor.isUserLoggedIn
    }
    
    init(loginInteractor: LoginInteractorProtocol) {
        self.loginInteractor = loginInteractor
        
        cartDefaults.publisher
            .sink { [weak self] cart in
                self?.cart = cart
            }
            .store(in: &cancellables)
    }
    
    func addItemToCart(with itemId: Int, productId: Int, quantity: Int) {
        if let cart = cartDefaults.getLatestValue() {
            let newItems = cart.items.map { CartItem(id: $0.id, productId: $0.productId, quantity: $0.quantity)} + [(.init(id: itemId, productId: productId, quantity: quantity))]
            let newCart = CartPresentationModel(Cart(cartId: cart.cartId, items: newItems))
            cartDefaults.save(newCart)
        }
    }
    
    func addProductToCart(_ product: ProductPresentationModel, with quantity: Int) -> AnyPublisher<AddToCartResponse, any Error> {
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let cartId = getStoredCartId() else { return
            Fail(error: AddToCartError.cartNotFound).eraseToAnyPublisher()
        }
        
        guard let url = APIConfig.url(for: .getCartItems(cartId)) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let addedProduct: AddToCartBody = .init(productId: product.id, quantity: quantity)
        request.httpBody = try? JSONEncoder().encode(addedProduct)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: AddToCartResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    
    
    func fetchCart() -> AnyPublisher<Cart?, Error> {
        
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let cartId = getStoredCartId() else {
            return Future { promise in promise(.success(nil)) }
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
        }
        
        guard let url = APIConfig.url(for: .getCartItems(cartId)) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [CartItem].self, decoder: JSONDecoder())
            .map { [weak self] (cartItems: [CartItem]) in
                guard let self else { return .init(cartId: "", items: []) }
                let cart = Cart(cartId: cartId, items: cartItems)
                self.cartDefaults.save(.init(cart))
                return cart
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func createCart() -> AnyPublisher<Cart?, Error> {
        
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let url = APIConfig.url(for: .createCart) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: CartCreationResponse.self, decoder: JSONDecoder())
            .map { [weak self] cartCreationResponse in
                guard let self = self else { return .init(cartId: "", items: []) }
                if cartCreationResponse.created {
                    let cart = Cart(cartId: cartCreationResponse.cartId, items: [])
                    self.cartDefaults.save(.init(cart))
                    return cart
                }
                return nil
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func storeCartId(with cartId: String) {
        UserDefaults.standard.set(cartId, forKey: "cartId")
    }

    func getStoredCartId() -> String? {
        return UserDefaults.standard.string(forKey: "cartId")
    }
}
