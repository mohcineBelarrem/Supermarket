//
//  OrderItemRouter.swift
//  Supermarket
//
//  Created by Mohcine on 24/11/2024.
//

import SwiftUI
import SwiftData

protocol OrderItemRouterProtocol {
    static func createModule(with orderItem: OrderItemPresentationModel) -> AnyView
}

class OrderItemRouter: OrderItemRouterProtocol {
    static func createModule(with orderItem: OrderItemPresentationModel) -> AnyView {
        
        let router = OrderItemRouter()
        let interactor = OrderItemInteractor()
        
        let presenter = OrderItemPresenter(router: router, interactor: interactor)
        presenter.item = orderItem
        return AnyView(OrderItemView(presenter: presenter))
    }
}
