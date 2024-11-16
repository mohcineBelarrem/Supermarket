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
//    func navigateToMainView() -> AnyView {
//        return AnyView(MainView())
//    }
    
    static func createModule(with modelContext: ModelContext) -> AnyView {
        
        let userProfileService = UserProfileService(modelContext: modelContext)
        let productService = ProductService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: userProfileService)
        let service = CartService(modelContext: modelContext)
        let productDetailInteractor = ProductDetailInteractor(loginInteractor: loginInteractor, productService: productService)
        let productListInteractor = ProductListInteractor(productDetailInteractor: productDetailInteractor, service: productService)
        let cartInteractor = CartInteractor(service: service, loginInteractor: loginInteractor, productListInteractor: productListInteractor)
        let router = MainRouter()
//        let router = CartRouter(tabController: tabController)
//        let presenter = CartPresenter(interactor: cartInteractor, router: router)
//        
//        
//        let interactor = APIStatusInteractor()
//        let router = APIStatusRouter()
        let presenter = MainPresenter(interactor: cartInteractor, router: router)
//
//        return AnyView(APIStatusView(presenter: presenter))
        return AnyView(MainView(presenter: presenter))
    }
}
