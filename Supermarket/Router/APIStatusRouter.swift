//
//  APIStatusRouter.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import SwiftUI
import SwiftData

protocol APIStatusRouterProtocol {
    static func createModule() -> AnyView
    func navigateToMainView(with modelContext: ModelContext) -> AnyView
}

class APIStatusRouter: APIStatusRouterProtocol {
    func navigateToMainView(with modelContext: ModelContext) -> AnyView {
        return MainRouter.createModule(with: modelContext)
    }
    
    static func createModule() -> AnyView {
        let interactor = APIStatusInteractor()
        let router = APIStatusRouter()
        let presenter = APIStatusPresenter(interactor: interactor, router: router)
        
        return AnyView(APIStatusView(presenter: presenter))
    }
}
