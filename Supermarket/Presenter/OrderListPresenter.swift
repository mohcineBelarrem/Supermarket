//
//  OrderListPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//


import Foundation
import SwiftUI
import SwiftData
import Combine

protocol OrderListPresenterProtocol: ObservableObject {
    func viewDidLoad()
    var isUserLoggedIn: Bool { get }
}


class OrderListPresenter: OrderListPresenterProtocol {
    private let interactor: OrderListInteractorProtocol
    private let router: OrderListRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var orders: [OrderItem] = []
    
    init(interactor: OrderListInteractorProtocol, router: OrderListRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    var isUserLoggedIn: Bool {
        interactor.isUserLoggedIn
    }
    
    func viewDidLoad() {
        fetchOrders()
    }
    
    
    private func fetchOrders() {
        isLoading = true
        interactor.fetchOrders()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Error Making Order: \(error.localizedDescription)"
                }
            } receiveValue: {[weak self] orderItems in
                guard let self else { return }
                self.isLoading = false
                self.orders = orderItems
            }
            .store(in: &cancellables)
    }
}
