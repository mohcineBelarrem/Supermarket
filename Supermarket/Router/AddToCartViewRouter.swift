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
        let productListInteractor = ProductListInteractor()
        let interactor = CartInteractor(loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let router = AddToCartViewRouter()
        let presenter = AddToCartViewPresenter(interactor: interactor, router: router)

        return AnyView(AddToCartView(presenter: presenter, product: product))
    }
}
