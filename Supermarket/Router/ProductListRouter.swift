//
//  ProductListRouter.swift
//  Supermarket
//
//  Created by Mohcine on 11/10/2024.
//

import SwiftUI


protocol ProductListRouterProtocol {
    static func createModule() -> AnyView
    func routeToDetailView(for id: Int) -> AnyView
}

class ProductListRouter: ProductListRouterProtocol {
    static func createModule() -> AnyView {
        let interactor = ProductListInteractor()
        let router = ProductListRouter()
        let presenter = ProductListPresenter(interactor: interactor, router: router)
        
        return AnyView(ProductListView(presenter: presenter))
    }
    
    func routeToDetailView(for id: Int) -> AnyView {
        ProductDetailRouter.createModule(with: id)
    }
}
