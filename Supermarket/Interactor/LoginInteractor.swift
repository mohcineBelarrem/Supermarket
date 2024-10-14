//
//  LoginInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import Foundation
import Combine

protocol LoginInteractorProtocol {
    var isUserLoggedIn: Bool { get }
    func login(username: String, email: String) -> AnyPublisher<UserCreationResponse, Error>
    func store(user: UserPresentationModel)
    func retrieveStoredCredentials() -> UserPresentationModel?
    func clearStoredCredentials()
}

class LoginInteractor: LoginInteractorProtocol {
    
    var isUserLoggedIn: Bool {
        retrieveStoredCredentials() != nil
    }
    
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
    
    func store(user: UserPresentationModel) {
        KeychainHelper.save(user.email, forKey: UserPresentationModelKeys.email.rawValue)
        KeychainHelper.save(user.username, forKey: UserPresentationModelKeys.username.rawValue)
        KeychainHelper.save(user.accessToken, forKey: UserPresentationModelKeys.accessToken.rawValue)
    }
    
    func retrieveStoredCredentials() -> UserPresentationModel? {
        guard let email = KeychainHelper.read(forKey: UserPresentationModelKeys.email.rawValue),
              let username = KeychainHelper.read(forKey: UserPresentationModelKeys.username.rawValue),
              let accessToken = KeychainHelper.read(forKey: UserPresentationModelKeys.accessToken.rawValue) else { return nil }
        return .init(username: username, email: email, accessToken: accessToken)
    }
    
    func clearStoredCredentials() {
        KeychainHelper.delete(forKey: UserPresentationModelKeys.username.rawValue)
        KeychainHelper.delete(forKey: UserPresentationModelKeys.email.rawValue)
        KeychainHelper.delete(forKey: UserPresentationModelKeys.accessToken.rawValue)
    }
    
}
