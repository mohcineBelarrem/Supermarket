//
//  CartRouter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI
import SwiftData


protocol CartRouterProtocol {
    static func createModule(with mainPresenter: MainPresenter, modelContext: ModelContext) -> AnyView
    func routeToCartButton(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView 
    func goToLogin()
    func goToProductList()
}


class CartRouter: CartRouterProtocol {
    private let mainPresenter: MainPresenter
    
    init(mainPresenter: MainPresenter) {
        self.mainPresenter = mainPresenter
    }
    
    func goToLogin() {
        mainPresenter.switchToLoginTab()
    }
    
    func goToProductList() {
        mainPresenter.switchToProductListTab()
    }
    
    func routeToCartButton(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView {
        CartButtonRouter.createModule(with: product, modelContext: modelContext)
    }

    static func createModule(with mainPresenter: MainPresenter, modelContext: ModelContext) -> AnyView {
        let userProfileService = UserProfileService(modelContext: modelContext)
        let productService = ProductService(modelContext: modelContext)
        let service = CartService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: userProfileService, cartService: service)
        let productDetailInteractor = ProductDetailInteractor(loginInteractor: loginInteractor, productService: productService)
        let productListInteractor = ProductListInteractor(productDetailInteractor: productDetailInteractor, service: productService)
        let cartInteractor = CartInteractor(service: service, loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let router = CartRouter(mainPresenter: mainPresenter)
        let presenter = CartPresenter(interactor: cartInteractor, router: router)
        
        
        return AnyView(CartView(presenter: presenter))
    }
}
