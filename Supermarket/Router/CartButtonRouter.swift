//
//  CartButtonRouter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI
import SwiftData


protocol CartButtonRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView
}

class CartButtonRouter: CartButtonRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView {
        let service = UserProfileService(modelContext: modelContext)
        let productService = ProductService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: service)
        let productDetailInteractor = ProductDetailInteractor(loginInteractor: loginInteractor, productService: productService)
        let productListInteractor = ProductListInteractor(productDetailInteractor: productDetailInteractor, service: productService)
        let cartInteractor = CartInteractor(loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let interactor = CartButtonInteractor(cartInteractor: cartInteractor)
        let router = CartButtonRouter()
        let presenter = CartButtonPresenter(interactor: interactor, router: router)

        return AnyView(CartButton(presenter: presenter, product: product))
    }
}
