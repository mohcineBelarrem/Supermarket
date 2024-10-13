//
//  LoginPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 13/10/2024.
//

import Combine
import SwiftUI

protocol LoginPresenterProtocol: ObservableObject {
    var user: UserPresentationModel? { get }
    var errorMessage: String? { get }
    func login(username: String, email: String)
    func profileView(for user: UserPresentationModel) -> AnyView
    func logout()
}

class LoginPresenter: ObservableObject, LoginPresenterProtocol {
    private let interactor: LoginInteractorProtocol
    private let router: LoginRouterProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var user: UserPresentationModel?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
   init(interactor: LoginInteractorProtocol, router: LoginRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.user = interactor.retrieveStoredCredentials()
    }

    func login(username: String, email: String) {
        isLoading = true
        interactor.login(username: username, email: email)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }, receiveValue: { userCreationResponse in
                let user: UserPresentationModel = .init(username: username, email: email, accessToken: userCreationResponse.accessToken)
                self.user = user
                self.interactor.store(user: user)
                self.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func profileView(for user: UserPresentationModel) -> AnyView {
        router.routeToProfileView(for: user)
    }
    
    func logout() {
        interactor.clearStoredCredentials()
        user = nil
    }
}
