//
//  OrderListRouter.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//


import SwiftUI
import SwiftData

protocol OrderListRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView
    func routeOrderItemView(for orderItem: OrderItemPresentationModel) -> AnyView
}

class OrderListRouter: OrderListRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView {
        let service = ProductService(modelContext: modelContext)
        let userProfileService = UserProfileService(modelContext: modelContext)
        let cartService = CartService(modelContext: modelContext)
        let orderService = OrderService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: userProfileService, cartService: cartService)
        let interactor = OrderListInteractor(loginInteractor: loginInteractor, productService: service, orderService: orderService)
        let router = OrderListRouter()
        let presenter = OrderListPresenter(interactor: interactor, router: router)
        
        return AnyView(OrderListView(presenter: presenter))
    }
    
    func routeOrderItemView(for orderItem: OrderItemPresentationModel) -> AnyView {
        OrderItemRouter.createModule(with: orderItem)
    }
}
