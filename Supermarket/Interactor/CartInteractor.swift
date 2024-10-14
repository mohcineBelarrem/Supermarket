//
//  CartInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation
import Combine

protocol CartInteractorProtocol {
    func fetchCart(with cartId: String) -> AnyPublisher<[CartItem], Error>
    func createCart() -> AnyPublisher<CartCreationResponse, Error>
    func storeCartId(with cartId: String)
    func getStoredCartId() -> String?
}

class CartInteractor: CartInteractorProtocol {
    
    private let loginInteractor: LoginInteractorProtocol
    
    init(loginInteractor: LoginInteractorProtocol) {
        self.loginInteractor = loginInteractor
    }
    
    func fetchCart(with cartId: String) -> AnyPublisher<[CartItem], Error> {
        
        guard let user = loginInteractor.retrieveStoredCredentials() else { return
            Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
//        guard let cartId = getStoredCartId() else { return
//            Fail(error: CartError.noCartId).eraseToAnyPublisher()
//        }
        
        guard let url = APIConfig.url(for: .getCartItems(cartId)) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [CartItem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func createCart() -> AnyPublisher<CartCreationResponse, Error> {
        
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
