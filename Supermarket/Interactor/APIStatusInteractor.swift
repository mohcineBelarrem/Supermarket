//
//  APIStatusInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Combine
import Foundation

protocol APIStatusInteractorProtocol {
    func checkAPIStatus() -> AnyPublisher<Bool, Error>
}

class APIStatusInteractor: APIStatusInteractorProtocol {
    
    func checkAPIStatus() -> AnyPublisher<Bool, Error> {
        guard let url = APIConfig.url(for: .apiStatus) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
       
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: APIStatus.self, decoder: JSONDecoder())
            .map { $0.status == "UP" }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
