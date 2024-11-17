//
//  AddToCartViewRouter.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

import SwiftUI
import SwiftData


protocol AddToCartViewRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel, cartButtonPresenter: CartButtonPresenter, modelContext: ModelContext) -> AnyView
}

class AddToCartViewRouter: AddToCartViewRouterProtocol {
    
    static var isPresented: Bool = false
    
    static func createModule(with product: ProductDetailPresentationModel, cartButtonPresenter: CartButtonPresenter, modelContext: ModelContext) -> AnyView {
        let service = UserProfileService(modelContext: modelContext)
        let productService = ProductService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: service)
        let cartService = CartService(modelContext: modelContext)
        let productDetailInteractor = ProductDetailInteractor(loginInteractor: loginInteractor, productService: productService)
        let productListInteractor = ProductListInteractor(productDetailInteractor: productDetailInteractor, service: productService)
        let interactor = CartInteractor(service: cartService, loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let router = AddToCartViewRouter()
        let presenter = AddToCartViewPresenter(interactor: interactor, router: router)
        presenter.cartButtonPresenter = cartButtonPresenter

        return AnyView(AddToCartView(presenter: presenter, product: product))
    }
}
