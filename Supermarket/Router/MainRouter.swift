//
//  MainRouter.swift
//  Supermarket
//
//  Created by Mohcine on 15/11/2024.
//

import SwiftUI
import SwiftData

protocol MainRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView
}

class MainRouter: MainRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView {
        let userProfileService = UserProfileService(modelContext: modelContext)
        let productService = ProductService(modelContext: modelContext)
        let service = CartService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: userProfileService, cartService: service)
        let productDetailInteractor = ProductDetailInteractor(loginInteractor: loginInteractor, productService: productService)
        let productListInteractor = ProductListInteractor(productDetailInteractor: productDetailInteractor, service: productService)
        let cartInteractor = CartInteractor(service: service, loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let router = MainRouter()
        let presenter = MainPresenter(interactor: cartInteractor, router: router)
        return AnyView(MainView(presenter: presenter))
    }
}
