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
    
    @Published var showAlert: Bool = false
    
   init(interactor: LoginInteractorProtocol, router: LoginRouterProtocol) {
        self.interactor = interactor
        self.router = router
        self.user = interactor.retrieveStoredCredentials()
    }

    func login(username: String, email: String) {
        isLoading = true
        interactor.login(username: username, email: email)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                if case .failure(let error) = completion {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] userCreationResponse in
                guard let self else { return }
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
        //TODO: Clear cartId also
        interactor.clearStoredCredentials()
        user = nil
    }
}
