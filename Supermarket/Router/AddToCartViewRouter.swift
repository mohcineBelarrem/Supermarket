//
//  AddToCartViewRouter.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

import SwiftUI


protocol AddToCartViewRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel) -> AnyView
}

class AddToCartViewRouter: AddToCartViewRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel) -> AnyView {
        let loginInteractor = LoginInteractor()
        let cartInteractor = CartInteractor(loginInteractor: loginInteractor)
        let interactor = AddToCartInteractor(cartInteractor: cartInteractor)
        let router = AddToCartViewRouter()
        let presenter = AddToCartViewPresenter(interactor: interactor, router: router)

        return AnyView(AddToCartView(presenter: presenter, product: product))
    }
}
