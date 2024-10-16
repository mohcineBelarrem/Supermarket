//
//  CartButtonPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 14/10/2024.
//

import Foundation
import Combine
import SwiftUI

protocol CartButtonPresenterProtocol: ObservableObject {
    var productQuantityInCart: Int? { get }
    func getProductQuantityInCart(for product: ProductDetailPresentationModel)
}


class CartButtonPresenter: CartButtonPresenterProtocol {
    private let interactor: CartButtonInteractorProtocol
    private let router: CartButtonRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var productQuantityInCart: Int?
    @Published var isButtonEnabled: Bool = true
    @Published var isLoading: Bool = false
    
    init(interactor: CartButtonInteractorProtocol, router: CartButtonRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func getProductQuantityInCart(for product: ProductDetailPresentationModel) {
        isLoading = true
        interactor.fetchProductQuantity(with: product.id)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] quantity in
                guard let self else { return }
                self.isLoading = false
                self.productQuantityInCart = quantity
                self.isButtonEnabled = quantity != nil && product.inStock
            }
            .store(in: &cancellables)
    }
}
