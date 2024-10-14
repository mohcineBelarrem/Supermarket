//
//  CartRouter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI


protocol CartRouterProtocol {
    static func createModule() -> AnyView
}


class CartRouter: CartRouterProtocol {
    static func createModule() -> AnyView {
        let loginInteractor = LoginInteractor()
        let cartInteractor = CartInteractor(loginInteractor: loginInteractor)
        let router = CartRouter()
        let presenter = CartPresenter(interactor: cartInteractor, router: router)
        
        
        return AnyView(CartView(presenter: presenter))
    }
}
