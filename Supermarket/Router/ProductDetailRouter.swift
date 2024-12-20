//
//  ProductDetailRouter.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//


import SwiftUI
import SwiftData

protocol ProductDetailRouterProtocol {
    static func createModule(with id: Int, modelContext: ModelContext) -> AnyView
    func routeToAddtoCartButton(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView
}

class ProductDetailRouter: ProductDetailRouterProtocol {
    static func createModule(with id: Int, modelContext: ModelContext) -> AnyView {
        let service = UserProfileService(modelContext: modelContext)
        let productService = ProductService(modelContext: modelContext)
        let cartService = CartService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: service, cartService: cartService)
        let interactor = ProductDetailInteractor(loginInteractor: loginInteractor, productService: productService)
        let router = ProductDetailRouter()
        let presenter = ProductDetailPresenter(interactor: interactor, router: router)
        
        return AnyView(ProductDetailView(presenter: presenter, productId: id))
    }
    
    func routeToAddtoCartButton(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView {
        CartButtonRouter.createModule(with: product, modelContext: modelContext)
    }
}
