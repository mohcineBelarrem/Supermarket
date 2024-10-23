//
//  AddToCartViewPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

import Foundation
import Combine
import SwiftUI

protocol AddToCartViewPresenterProtocol: ObservableObject {
    var quantity: Int { get set }
    var buttonQuantity: Int? { get }
    func quantityRange(for product: ProductDetailPresentationModel) -> ClosedRange<Int>
    func totalFormattedPrice(for product: ProductDetailPresentationModel) -> String
    func addProdtuctToCart(_ product: ProductDetailPresentationModel)
}


class AddToCartViewPresenter: AddToCartViewPresenterProtocol {
    private let interactor: CartInteractorProtocol
    private let router: AddToCartViewRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var quantity: Int = 1
    @Published var isLoading: Bool = false
    @Published var buttonQuantity: Int? = nil
    
    
    init(interactor: CartInteractorProtocol, router: AddToCartViewRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func addProdtuctToCart(_ product: ProductDetailPresentationModel) {
        isLoading = true
        interactor.addProductToCart(product.product, with: quantity)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.created {
                    self.buttonQuantity = quantity
                    interactor.addItemToCart(with: response.itemId, productId: product.id, quantity: quantity)
                }
            }
            .store(in: &cancellables)
    }
    
    
    func quantityRange(for product: ProductDetailPresentationModel) -> ClosedRange<Int> {
        return 1...product.currentStock
    }
    
    func totalFormattedPrice(for product: ProductDetailPresentationModel) -> String {
        let total = Double(quantity) * product.price
        return total.formattedPrice
    }
    
}
