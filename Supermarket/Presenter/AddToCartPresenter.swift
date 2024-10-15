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
    func getProductQuantityInCart(for product: ProductPresentationModel)
}


class AddToCartPresenter: AddToCartPresenterProtocol {
    private let interactor: AddToCartInteractorProtocol
    private let router: AddToCartRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var productQuantityInCart: Int?
    @Published var isButtonEnabled: Bool = true
    @Published var isLoading: Bool = false
    
    init(interactor: AddToCartInteractorProtocol, router: AddToCartRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func getProductQuantityInCart(for product: ProductPresentationModel) {
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
