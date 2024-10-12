//
//  APIStatusRouter.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI

protocol APIStatusRouterProtocol {
    static func createModule() -> AnyView
    func navigateToProductListScreen() -> AnyView
}

class APIStatusRouter: APIStatusRouterProtocol {
    func navigateToProductListScreen() -> AnyView {
        return ProductListRouter.createModule()
    }
    
    static func createModule() -> AnyView {
        let interactor = APIStatusInteractor()
        let router = APIStatusRouter()
        let presenter = APIStatusPresenter(interactor: interactor, router: router)
        
        return AnyView(APIStatusView(presenter: presenter))
    }
}
