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
    func quantityRange(for product: ProductDetailPresentationModel) -> ClosedRange<Int>
    func totalFormattedPrice(for product: ProductDetailPresentationModel) -> String
}


class AddToCartViewPresenter: AddToCartViewPresenterProtocol {
    private let interactor: AddToCartInteractorProtocol
    private let router: AddToCartViewRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var quantity: Int = 1
    
    init(interactor: AddToCartInteractorProtocol, router: AddToCartViewRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func quantityRange(for product: ProductDetailPresentationModel) -> ClosedRange<Int> {
        return 1...product.currentStock
    }
    
    func totalFormattedPrice(for product: ProductDetailPresentationModel) -> String {
        let total = Double(quantity) * product.price
        return total.formattedPrice
    }
    
}
