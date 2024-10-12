//
//  APIStatusPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Combine
import SwiftUI

class APIStatusPresenter: ObservableObject {
    private let interactor: APIStatusInteractorProtocol
    private let router: APIStatusRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isAPIHealthy: Bool = false
    @Published var errorMessage: String?
    @Published var currentView: AnyView? = nil

    init(interactor: APIStatusInteractorProtocol, router: APIStatusRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func checkAPIStatus() {
        interactor.checkAPIStatus()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { isHealthy in
                self.isAPIHealthy = isHealthy
                if isHealthy {
                    self.currentView = self.router.navigateToProductListScreen()
                }
            })
            .store(in: &cancellables)
    }
}
