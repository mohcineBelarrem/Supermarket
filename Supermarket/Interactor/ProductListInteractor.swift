//
//  ProductListInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import Combine
import Foundation

protocol ProductListInteractorProtocol {
    func fetchProducts() -> AnyPublisher<[Product], Error>
    func fetchProductDetail(for productId: Int) -> AnyPublisher<ProductDetail, Error>
}

class ProductListInteractor: ProductListInteractorProtocol {
    
    private let productDetailInteractor: ProductDetailInteractorProtocol
    
    init(productDetailInteractor: ProductDetailInteractorProtocol) {
        self.productDetailInteractor = productDetailInteractor
    }
    
    func fetchProducts() -> AnyPublisher<[Product], Error> {
        guard let url = APIConfig.url(for: .products) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Product].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchProductDetail(for productId: Int) -> AnyPublisher<ProductDetail, Error> {
        productDetailInteractor.getProductDetail(for: productId)
    }
}
