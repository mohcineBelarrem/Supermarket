//
//  AddToCartRouter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import SwiftUI


protocol AddToCartRouterProtocol {
    func routeToAddToCartButton(for product: ProductPresentationModel) -> AnyView
    static func createModule(with product: ProductPresentationModel) -> AnyView
}

class AddToCartRouter: AddToCartRouterProtocol {
    static func createModule(with product: ProductPresentationModel) -> AnyView {
        let interactor = AddToCartInteractor()
        let router = AddToCartRouter()
        let presenter = AddToCartPresenter(interactor: interactor, router: router)

        return AnyView(AddToCartButton(presenter: presenter, product: product))
    }
    
    func routeToAddToCartButton(for product: ProductPresentationModel) -> AnyView {
        AnyView(AddToCartRouter.createModule(with: product))
    }
    
}
