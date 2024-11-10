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
    func store(products: [ProductDetailPresentationModel])
    func retrieveProducts() -> [ProductDetailPresentationModel]
    func deleteCatalog()
}

class ProductListInteractor: ProductListInteractorProtocol {
    private let productDetailInteractor: ProductDetailInteractorProtocol
    private let service: ProductServiceProtocol
    
    init(productDetailInteractor: ProductDetailInteractorProtocol, service: ProductServiceProtocol) {
        self.productDetailInteractor = productDetailInteractor
        self.service = service
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
    
    func store(products: [ProductDetailPresentationModel]) {
        service.save(products: products)
    }
    
    func retrieveProducts() -> [ProductDetailPresentationModel] {
        service.fetchProducts()
    }
    
    func deleteCatalog() {
        service.deleteProducts()
    }
}
