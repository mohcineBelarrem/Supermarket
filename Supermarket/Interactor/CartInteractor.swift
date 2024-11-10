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
    func fetchProducts() -> AnyPublisher<[Product], Error>
    func createCart() -> AnyPublisher<Cart?, Error>
    func storeCartId(with cartId: String)
    func getStoredCartId() -> String?
    //func addItemToCart(with itemId: Int, productId: Int, quantity: Int)
    
    
    func addProductToCart(with productId: Int, and quantity: Int) -> AnyPublisher<AddToCartResponse, Error>
    func editItemInCart(itemId: Int, with quantity: Int) -> AnyPublisher<Bool, Error>
    func deleteItemFromCart(with itemCartId: Int) -> AnyPublisher<Bool, Error>
}

class CartInteractor: CartInteractorProtocol {
    //private var cartDefaults = UserDefaultsPublisher<CartPresentationModel>(userDefaults: .standard, key: "cart")
    private let loginInteractor: LoginInteractorProtocol
    private let productListInteractor: ProductListInteractorProtocol
    
    
    @Published var cart: CartPresentationModel?
//    private var cancellables = Set<AnyCancellable>()
    
    var isUserLoggedIn: Bool {
        loginInteractor.isUserLoggedIn
    }
    
    init(loginInteractor: LoginInteractorProtocol, productListInteractor: ProductListInteractorProtocol) {
        self.loginInteractor = loginInteractor
        self.productListInteractor = productListInteractor
        
//        cartDefaults.publisher
//            .sink { [weak self] cart in
//                self?.cart = cart
//            }
//            .store(in: &cancellables)
    }
    
    func fetchProducts() -> AnyPublisher<[Product], Error> {
        productListInteractor.fetchProducts()
    }
    
//    func addItemToCart(with itemId: Int, productId: Int, quantity: Int) {
//        if let cart = cartDefaults.getLatestValue() {
//            let newItems = cart.items.map { CartItem(id: $0.id, productId: $0.productId, quantity: $0.quantity)} + [(.init(id: itemId, productId: productId, quantity: quantity))]
//            let newCart = CartPresentationModel(Cart(cartId: cart.cartId, items: newItems))
//            cartDefaults.save(newCart)
//        }
//    }
    
    func addProductToCart(with productId: Int, and quantity: Int) -> AnyPublisher<AddToCartResponse, any Error> {
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let cartId = getStoredCartId() else { return
            Fail(error: CartError.cartNotFound).eraseToAnyPublisher()
        }
        
        guard let url = APIConfig.url(for: .getCartItems(cartId)) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let addedProduct: AddToCartBody = .init(productId: productId, quantity: quantity)
        request.httpBody = try? JSONEncoder().encode(addedProduct)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: AddToCartResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    
    func editItemInCart(itemId: Int, with quantity: Int) -> AnyPublisher<Bool, any Error> {
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let cartId = getStoredCartId() else { return
            Fail(error: CartError.cartNotFound).eraseToAnyPublisher()
        }
        
        guard let url = APIConfig.url(for: .editCartItem(cartId, itemId)) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let editCartItemBody: EditCartItemBody = .init(quantity: quantity)
        request.httpBody = try? JSONEncoder().encode(editCartItemBody)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse else { throw CartError.badServerResponse }
                return response.statusCode == 204
                }
            .eraseToAnyPublisher()
    }
    
    
    
    func fetchCart() -> AnyPublisher<Cart?, Error> {
        
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let cartId = getStoredCartId() else {
            return Future { promise in promise(.success(nil)) }
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
                //self.cartDefaults.save(.init(cart))
                return cart
            }
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
                    //self.cartDefaults.save(.init(cart))
                    return cart
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    func deleteItemFromCart(with itemCartId: Int) -> AnyPublisher<Bool, Error> {
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let cartId = getStoredCartId() else { return
            Fail(error: CartError.cartNotFound).eraseToAnyPublisher()
        }
        
        guard let url = APIConfig.url(for: .deleteCartItem(cartId, itemCartId)) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse else { throw CartError.badServerResponse }
                return response.statusCode == 204
                }
            .eraseToAnyPublisher()
    }

    func storeCartId(with cartId: String) {
        UserDefaults.standard.set(cartId, forKey: "cartId")
    }

    func getStoredCartId() -> String? {
        return UserDefaults.standard.string(forKey: "cartId")
    }
}
