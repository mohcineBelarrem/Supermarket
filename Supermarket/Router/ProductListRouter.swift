//
//  ProductListRouter.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI


protocol ProductListRouterProtocol {
    static func createModule() -> AnyView
    func routeToDetailView(for product: ProductPresentationModel) -> AnyView
    func routeToProductView(for product: ProductPresentationModel) -> AnyView
}

class ProductListRouter: ProductListRouterProtocol {
    static func createModule() -> AnyView {
        let interactor = ProductListInteractor()
        let router = ProductListRouter()
        let presenter = ProductListPresenter(interactor: interactor, router: router)
        
        return AnyView(ProductListView(presenter: presenter))
    }
    
    func routeToDetailView(for product: ProductPresentationModel) -> AnyView {
        ProductDetailRouter.createModule(with: product.id)
    }
    
    func routeToProductView(for product: ProductPresentationModel) -> AnyView {
        AnyView(ProductView(product: product))
    }
}
