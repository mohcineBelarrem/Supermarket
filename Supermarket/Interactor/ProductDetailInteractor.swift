//
//  ProductDetailInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Combine
import Foundation

protocol ProductDetailInteractorProtocol {
    var isUserLoggedIn: Bool { get }
    func getProductDetail(for productId: Int) -> AnyPublisher<ProductDetail, Error>
    func retrieveProduct(with productId: Int) -> ProductDetailPresentationModel?
}

class ProductDetailInteractor: ProductDetailInteractorProtocol {
    
    private let loginInteractor: LoginInteractorProtocol
    private let productService: ProductServiceProtocol
    
    var isUserLoggedIn: Bool {
        loginInteractor.isUserLoggedIn
    }
    
    init(loginInteractor: LoginInteractorProtocol, productService: ProductServiceProtocol) {
        self.loginInteractor = loginInteractor
        self.productService = productService
    }
    
    func retrieveProduct(with productId: Int) -> ProductDetailPresentationModel? {
        productService.fetchProduct(with: productId)
    }
    
    func getProductDetail(for productId: Int) -> AnyPublisher<ProductDetail, Error> {
        guard let url = APIConfig.url(for: .productDetail(productId)) else { return
            Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ProductDetail.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
