//
//  CartButtonRouter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI


protocol CartButtonRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel) -> AnyView
}

class CartButtonRouter: CartButtonRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel) -> AnyView {
        let loginInteractor = LoginInteractor()
        let productListInteractor = ProductListInteractor()
        let cartInteractor = CartInteractor(loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let interactor = CartButtonInteractor(cartInteractor: cartInteractor)
        let router = CartButtonRouter()
        let presenter = CartButtonPresenter(interactor: interactor, router: router)

        return AnyView(CartButton(presenter: presenter, product: product))
    }
}
