//
//  ProductListRouter.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI
import SwiftData


protocol ProductListRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView
    func routeToDetailView(for productId: Int, modelContext: ModelContext) -> AnyView
    func routeToProductView(for product: ProductDetailPresentationModel) -> AnyView
}

class ProductListRouter: ProductListRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView {
        
        let service = UserProfileService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: service)
        let productDetailInteractor = ProductDetailInteractor(loginInteractor: loginInteractor)
        let interactor = ProductListInteractor(productDetailInteractor: productDetailInteractor)
        let router = ProductListRouter()
        let presenter = ProductListPresenter(interactor: interactor, router: router)
        
        return AnyView(ProductListView(presenter: presenter))
    }
    
    func routeToDetailView(for productId: Int, modelContext: ModelContext) -> AnyView {
        ProductDetailRouter.createModule(with: productId, modelContext: modelContext)
    }
    
    func routeToProductView(for product: ProductDetailPresentationModel) -> AnyView {
        AnyView(ProductView(product: product))
    }
}
