//
//  ProductService.swift
//  Supermarket
//
//  Created by Mohcine on 10/11/2024.
//

import Foundation
import Combine
import SwiftData

protocol ProductServiceProtocol {
    var notificationPublisher: AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> { get }
    
    func fetchProducts() -> [ProductDetailPresentationModel]
    func fetchProduct(with id: Int) -> ProductDetailPresentationModel?
    func save(products: [ProductDetailPresentationModel])
    func deleteProducts()
}

class ProductService: ProductServiceProtocol {
    private let modelContext: ModelContext
    
    var notificationPublisher: AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> {
        NotificationCenter.default.publisher(for: ModelContext.didSave)
             .eraseToAnyPublisher()
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchProducts() -> [ProductDetailPresentationModel] {
        let predicate = #Predicate<ProductDetailPresentationModel> { _ in true }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            return []
        }
    }
    
    func fetchProduct(with id: Int) -> ProductDetailPresentationModel? {
        let predicate = #Predicate<ProductDetailPresentationModel> { product in product.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        let result = try? modelContext.fetch(descriptor)
        return result?.first
        
    }
    
    func save(products: [ProductDetailPresentationModel]) {
        for product in products {
            modelContext.insert(product)
        }
    }
    
    func deleteProducts() {
        let products = fetchProducts()
        for product in products {
            modelContext.delete(product)
        }
    }
}
