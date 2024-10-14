//
//  AddToCartPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation
import Combine
import SwiftUI

protocol AddToCartPresenterProtocol: ObservableObject {
    var productQuantityInCart: Int? { get }
    func getProductQuantityInCart(for productId: Int)
}


class AddToCartPresenter: AddToCartPresenterProtocol {
    private let interactor: AddToCartInteractorProtocol
    private let router: AddToCartRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var productQuantityInCart: Int?
    
    init(interactor: AddToCartInteractorProtocol, router: AddToCartRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func getProductQuantityInCart(for productId: Int) {
        interactor.fetchProductQuantity(with: productId)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            } receiveValue: { quantity in
                self.productQuantityInCart = quantity
            }
            .store(in: &cancellables)
    }
}
