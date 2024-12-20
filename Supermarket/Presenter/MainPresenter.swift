//
//  MainPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 15/11/2024.
//

import Combine
import SwiftUI


enum Tab {
    case cart
    case login
    case productList
    case orderList
}

protocol MainPresenterProtocol: ObservableObject {
    var numberOfProducts: Int? { get }
    var selectedTab: Tab { get }
    func switchToLoginTab()
    func switchToCartTab()
    func switchToProductListTab()
}


class MainPresenter: MainPresenterProtocol {
    private let interactor: CartInteractorProtocol
    private let router: MainRouterProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var selectedTab: Tab = .productList
    @Published var numberOfProducts: Int? = nil
    
    init(interactor: CartInteractorProtocol, router: MainRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func switchToLoginTab() {
        selectedTab = .login
    }

    func switchToCartTab() {
        selectedTab = .cart
    }

    func switchToProductListTab() {
        selectedTab = .productList
    }
    
    
    func viewDidLoad() {
        self.numberOfProducts = interactor.retrieveCart()?.items.reduce(0) { $0 + $1.quantity }
        interactor.notificationPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.numberOfProducts = self?.interactor.retrieveCart()?.items.reduce(0) { $0 + $1.quantity }
            })
            .store(in: &cancellables)
    }
}
