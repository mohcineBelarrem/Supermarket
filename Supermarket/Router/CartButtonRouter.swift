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
        let interactor = CartButtonInteractor()
        let router = CartButtonRouter()
        let presenter = CartButtonPresenter(interactor: interactor, router: router)

        return AnyView(CartButton(presenter: presenter, product: product))
    }
}
