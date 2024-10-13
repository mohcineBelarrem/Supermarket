//
//  LoginRouter.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import SwiftUI

protocol LoginRouterProtocol {
    static func createModule() -> AnyView
    func routeToProfileView(for user: UserPresentationModel) -> AnyView
}

class LoginRouter: LoginRouterProtocol {
    static func createModule() -> AnyView {
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(interactor: interactor, router: router)
        
        return AnyView(LoginView(presenter: presenter))
    }
    
    func routeToProfileView(for user: UserPresentationModel) -> AnyView {
        return AnyView(ProfileView(user: user))
    }
}
