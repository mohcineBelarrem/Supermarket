//
//  AddToCartViewRouter.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

import SwiftUI
import SwiftData


protocol AddToCartViewRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView
}

class AddToCartViewRouter: AddToCartViewRouterProtocol {
    static func createModule(with product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView {
        let service = UserProfileService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: service)
        let productListInteractor = ProductListInteractor()
        let interactor = CartInteractor(loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let router = AddToCartViewRouter()
        let presenter = AddToCartViewPresenter(interactor: interactor, router: router)

        return AnyView(AddToCartView(presenter: presenter, product: product))
    }
}
