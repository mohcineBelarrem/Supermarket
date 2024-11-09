//
//  LoginRouter.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import SwiftUI
import SwiftData

protocol LoginRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView
    func routeToProfileView(for user: UserPresentationModel) -> AnyView
}

class LoginRouter: LoginRouterProtocol {
    static func createModule(with modelContext: ModelContext) -> AnyView {
        let service = UserProfileService(modelContext: modelContext)
        let interactor = LoginInteractor(service: service)
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, router: router)
        
        return AnyView(LoginView(presenter: presenter))
    }
    
    func routeToProfileView(for user: UserPresentationModel) -> AnyView {
        return AnyView(ProfileView(user: user))
    }
}
