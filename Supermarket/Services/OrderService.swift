//
//  OrderService.swift
//  Supermarket
//
//  Created by Mohcine on 24/11/2024.
//

import Foundation
import Combine
import SwiftData

protocol OrderServiceProtocol {
    var notificationPublisher: AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> { get }
    
    func retrieveOrders() -> [OrderItemPresentationModel]
    func retrieveOrder(with orderId: String) -> OrderItemPresentationModel?
    func save(orders: [OrderItemPresentationModel])
    func deleteOrders()
}

class OrderService: OrderServiceProtocol {
    private let modelContext: ModelContext
    
    var notificationPublisher: AnyPublisher<NotificationCenter.Publisher.Output, NotificationCenter.Publisher.Failure> {
        NotificationCenter.default.publisher(for: ModelContext.didSave)
             .eraseToAnyPublisher()
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func retrieveOrders() -> [OrderItemPresentationModel] {
        let predicate = #Predicate<OrderItemPresentationModel> { _ in true }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            return []
        }
    }
    
    func retrieveOrder(with orderId: String) -> OrderItemPresentationModel? {
        let predicate = #Predicate<OrderItemPresentationModel> { order in order.orderId == orderId }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        let result = try? modelContext.fetch(descriptor)
        return result?.first
        
    }
    
    func save(orders: [OrderItemPresentationModel]) {
        for order in orders {
            modelContext.insert(order)
        }
    }
    
    func deleteOrders() {
        let orders = retrieveOrders()
        for order in orders {
            modelContext.delete(order)
        }
    }
}
