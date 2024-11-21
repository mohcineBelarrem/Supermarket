//
//  OrderListInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//

import Foundation
import Combine
import SwiftData


protocol OrderListInteractorProtocol {
    var isUserLoggedIn: Bool { get }
    func fetchOrders() -> AnyPublisher<[OrderItem], Error>
}


class OrderListInteractor: OrderListInteractorProtocol {
    
    private let loginInteractor: LoginInteractorProtocol
    
    var isUserLoggedIn: Bool {
        loginInteractor.isUserLoggedIn
    }
    
    init(loginInteractor: LoginInteractorProtocol) {
        self.loginInteractor = loginInteractor
    }
    
    func fetchOrders() -> AnyPublisher<[OrderItem], Error> {
        guard let user = loginInteractor.retrieveStoredCredentials() else {
           return  Fail(error: URLError(.userAuthenticationRequired)).eraseToAnyPublisher()
        }
        
        guard let url = APIConfig.url(for: .orders) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: [OrderItem].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
