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
}

class OrderListRouter: OrderListRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView {
//        let service = OrderService(modelContext: modelContext)
        let userProfileService = UserProfileService(modelContext: modelContext)
        let cartService = CartService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: userProfileService, cartService: cartService)
        let interactor = OrderListInteractor(loginInteractor: loginInteractor)
        let router = OrderListRouter()
        let presenter = OrderListPresenter(interactor: interactor, router: router)
        
        return AnyView(OrderListView(presenter: presenter))
    }
    
}
