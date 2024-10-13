//
//  LoginInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import Foundation
import Combine

protocol LoginInteractorProtocol {
    func login(username: String, email: String) -> AnyPublisher<UserCreationResponse, Error>
}

class LoginInteractor: LoginInteractorProtocol {
    func login(username: String, email: String) -> AnyPublisher<UserCreationResponse, Error> {
        guard let url = APIConfig.url(for: .userRegistration) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user: UserCredentials = .init(clientName: username, clientEmail: email)
        request.httpBody = try? JSONEncoder().encode(user)
        
        //TODO: Improve the reading of error in case the user is duplicated
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: UserCreationResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
