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
    
    //Database
    var notificationPublisher: AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> { get }
    func retrieveProducts() -> [ProductDetailPresentationModel]
    func retrieveCart() -> CartPresentationModel?
    func saveCart(_ cart: CartPresentationModel)
    func saveItemToCart(cartItem: CartItemPresentationModel)
    func saveProduct(with productId: Int, with newQuantity: Int)
    func removeProductFromCart(with productId: Int)
    
    //Networking
    func addProductToCart(with productId: Int, and quantity: Int) -> AnyPublisher<AddToCartResponse, Error>
    func fetchCart() -> AnyPublisher<Cart?, Error>
    func createCart() -> AnyPublisher<Cart?, Error>
    func editItemInCart(itemId: Int, with quantity: Int) -> AnyPublisher<Bool, Error>
    func deleteItemFromCart(with itemCartId: Int) -> AnyPublisher<Bool, Error>
}

class CartInteractor: CartInteractorProtocol {
    private let loginInteractor: LoginInteractorProtocol
    private let productListInteractor: ProductListInteractorProtocol
    private let service: CartServiceProtocol
    
    var isUserLoggedIn: Bool {
        loginInteractor.isUserLoggedIn
    }
    
    var notificationPublisher: AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> {
        service.notificationPublisher
    }
    
    init(service: CartServiceProtocol, loginInteractor: LoginInteractorProtocol, productListInteractor: ProductListInteractorProtocol) {
        self.loginInteractor = loginInteractor
        self.productListInteractor = productListInteractor
        self.service = service
    }
    
    func retrieveProducts() -> [ProductDetailPresentationModel] {
        productListInteractor.retrieveProducts()
    }
    
    func retrieveCart() -> CartPresentationModel? {
        service.fetchCart()
    }
    
    func addProductToCart(with productId: Int, and quantity: Int) -> AnyPublisher<AddToCartResponse, any Error> {
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let cartId = service.fetchCart()?.cartId else { return
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
        
        guard let cartId = service.fetchCart()?.cartId else { return
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
        
        guard let cartId = service.fetchCart()?.cartId else {
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
            .map { (cartItems: [CartItem]) in
                return Cart(cartId: cartId, items: cartItems)
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
            .map { cartCreationResponse in
                if cartCreationResponse.created {
                    return Cart(cartId: cartCreationResponse.cartId, items: [])
                }
                return nil
            }
            .eraseToAnyPublisher()
    }
    
    func deleteItemFromCart(with itemCartId: Int) -> AnyPublisher<Bool, Error> {
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let cartId = service.fetchCart()?.cartId else { return
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

    func saveCart(_ cart: CartPresentationModel) {
        service.saveCart(cart)
    }
    
    func saveItemToCart(cartItem: CartItemPresentationModel) {
        service.saveItemToCart(cartItem: cartItem)
    }
    
    func saveProduct(with productId: Int, with newQuantity: Int) {
        service.editItem(with: productId, with: newQuantity)
    }
    
    func removeProductFromCart(with productId: Int) {
        service.removeProduct(with: productId)
    }
}
