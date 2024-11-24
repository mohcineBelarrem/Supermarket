//
//  OrderListPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//


import Foundation
import SwiftUI
import SwiftData
import Combine

protocol OrderListPresenterProtocol: ObservableObject {
    func viewDidLoad()
    func routeToOrderItemView(for orderItem: OrderItemPresentationModel) -> AnyView
    var isUserLoggedIn: Bool { get }
}


class OrderListPresenter: OrderListPresenterProtocol {
    private let interactor: OrderListInteractorProtocol
    private let router: OrderListRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var orders: [OrderItemPresentationModel] = []
    
    init(interactor: OrderListInteractorProtocol, router: OrderListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    var isUserLoggedIn: Bool {
        interactor.isUserLoggedIn
    }
    
    func viewDidLoad() {
        fetchOrders()
    }
    
    func routeToOrderItemView(for orderItem: OrderItemPresentationModel) -> AnyView {
        router.routeOrderItemView(for: orderItem)
    }
    
    private func fetchOrders() {
        isLoading = true
        interactor.fetchOrders()
            .compactMap { (orderItems: [OrderItem]) in
                
                return orderItems.compactMap { orderItem in
                    
                    let cartItems: [CartItemPresentationModel] = orderItem.items.compactMap { [weak self] in
                        guard let self else { return nil }
                        if let product = self.interactor.retrieveProduct(with: $0.productId) {
                            return .init(id: $0.id, productId: $0.productId, quantity: $0.quantity, product: product)
                        } else {
                            return nil
                        }
                    }
                    
                    return OrderItemPresentationModel(orderId: orderItem.orderId,
                                                      items: cartItems,
                                               created: orderItem.created)
                }
                
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Error Making Order: \(error.localizedDescription)"
                }
            } receiveValue: {[weak self] orderItems in
                guard let self else { return }
                self.isLoading = false
                self.orders = orderItems
                //self.save(fetchedOrders: orderItems)
            }
            .store(in: &cancellables)
    }
    
    
    private func save(fetchedOrders: [OrderItemPresentationModel]) {
        let savedOrdes = self.interactor.retrieveOrders()
        var ordersToSave: [OrderItemPresentationModel] = []
        for order in fetchedOrders {
            if !savedOrdes.contains(where: { $0.orderId == order.orderId }) {
                ordersToSave.append(order)
            }
        }
        self.interactor.save(orders: ordersToSave)
    }
}
