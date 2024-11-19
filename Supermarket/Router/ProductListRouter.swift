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
    func routeToCartButton(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView
    func routeToCategoryView(for category: CategoryPresentationModel) -> AnyView
}

class ProductListRouter: ProductListRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView {
        
        let service = UserProfileService(modelContext: modelContext)
        let productService = ProductService(modelContext: modelContext)
        let cartService = CartService(modelContext: modelContext)
        let loginInteractor = LoginInteractor(service: service, cartService: cartService)
        let productDetailInteractor = ProductDetailInteractor(loginInteractor: loginInteractor, productService: productService)
        let interactor = ProductListInteractor(productDetailInteractor: productDetailInteractor, service: productService)
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
    
    func routeToCartButton(for product: ProductDetailPresentationModel, modelContext: ModelContext) -> AnyView {
        CartButtonRouter.createModule(with: product, modelContext: modelContext)
    }
    
    func routeToCategoryView(for category: CategoryPresentationModel) -> AnyView {
        AnyView(CategoryView(category: category))
    }
}
