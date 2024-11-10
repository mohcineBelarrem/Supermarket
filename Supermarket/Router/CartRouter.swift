//
//  CartRouter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI
import SwiftData


protocol CartRouterProtocol {
    static func createModule(with tabController: TabController, modelContext: ModelContext) -> AnyView
    func goToLogin()
    func goToProductList()
}


class CartRouter: CartRouterProtocol {
    private let tabController: TabController
    
    init(tabController: TabController) {
        self.tabController = tabController
    }
    
    func goToLogin() {
        tabController.switchToLoginTab()
    }
    
    func goToProductList() {
        tabController.switchToProductListTab()
    }
    
    static func createModule(with tabController: TabController, modelContext: ModelContext) -> AnyView {
        let service = UserProfileService(modelContext: modelContext)
        let productService = ProductService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: service)
        let productDetailInteractor = ProductDetailInteractor(loginInteractor: loginInteractor)
        let productListInteractor = ProductListInteractor(productDetailInteractor: productDetailInteractor, service: productService)
        let cartInteractor = CartInteractor(loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let router = CartRouter(tabController: tabController)
        let presenter = CartPresenter(interactor: cartInteractor, router: router)
        
        
        return AnyView(CartView(presenter: presenter))
    }
}
