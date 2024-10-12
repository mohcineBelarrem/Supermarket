//
//  ProductDetailRouter.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//


import SwiftUI


protocol ProductDetailRouterProtocol {
    static func createModule(with id: Int) -> AnyView
}

class ProductDetailRouter: ProductDetailRouterProtocol {
    static func createModule(with id: Int) -> AnyView {
        let interactor = ProductDetailInteractor()
        let router = ProductDetailRouter()
        let presenter = ProductDetailPresenter(interactor: interactor, router: router)
        
        return AnyView(ProductDetailView(presenter: presenter, productId: id))
    }
}
