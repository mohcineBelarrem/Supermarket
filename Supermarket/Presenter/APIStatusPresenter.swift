//
//  APIStatusPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 12/10/2024.
//

import Combine
import SwiftUI
import SwiftData

class APIStatusPresenter: ObservableObject {
    private let interactor: APIStatusInteractorProtocol
    private let router: APIStatusRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var shouldNavigateToMainView: Bool = false

   
    init(interactor: APIStatusInteractorProtocol, router: APIStatusRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }

    func checkAPIStatus() {
        interactor.checkAPIStatus()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { isHealthy in
                self.shouldNavigateToMainView = isHealthy
            })
            .store(in: &cancellables)
    }
    
    func navigateToMainView(modelContext: ModelContext) -> AnyView {
        router.navigateToMainView(with: modelContext)
    }
}
