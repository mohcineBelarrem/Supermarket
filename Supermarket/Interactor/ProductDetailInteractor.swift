//
//  ProductDetailInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Combine
import Foundation

protocol ProductDetailInteractorProtocol {
    func getProductDetail(for productId: Int) -> AnyPublisher<ProductDetail, Error>
}

class ProductDetailInteractor: ProductDetailInteractorProtocol {
    
    func getProductDetail(for productId: Int) -> AnyPublisher<ProductDetail, Error> {
        guard let url = APIConfig.url(for: .productDetail(productId)) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ProductDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
