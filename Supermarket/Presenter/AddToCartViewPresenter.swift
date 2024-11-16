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
    func viewDidLoad(with product: ProductDetailPresentationModel)
    func buttonPressed(for product: ProductDetailPresentationModel)
}


class AddToCartViewPresenter: AddToCartViewPresenterProtocol {
    private let interactor: CartInteractorProtocol
    private let router: AddToCartViewRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    @Published var quantity: Int = 1
    @Published var isLoading: Bool = false
    @Published var buttonQuantity: Int? = nil
    
    private var initialQuantity: Int = 0
    
    var isButtonEnabbled: Bool {
        initialQuantity != quantity
    }
    
    var buttonText: String {
        if let buttonQuantity {
            if initialQuantity > 0 {
                return initialQuantity == quantity ? "\(buttonQuantity)" : "Update Cart (\(quantity))"
            } else {
                return "\(buttonQuantity)"
            }
        } else {
            return "Add to Cart"
        }
    }
    
    init(interactor: CartInteractorProtocol, router: AddToCartViewRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func buttonPressed(for product: ProductDetailPresentationModel) {
        if initialQuantity > 0 {
            editProductQuantity(product: product, with: quantity)
        } else {
            addProdtuctToCart(product)
        }
    }
    
    
    func viewDidLoad(with product: ProductDetailPresentationModel) {
        isLoading = true
        interactor.fetchCart()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Adding product to Cart failed: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] cart in
                guard let self = self else { return }
                self.isLoading = false
                
                if let quantity = cart?.items.filter({ $0.productId == product.id }).first?.quantity  {
                    self.initialQuantity = quantity
                    self.quantity = quantity
                    self.buttonQuantity = quantity
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
    
    private func editProductQuantity(product: ProductDetailPresentationModel, with newQuantity: Int) {
        isLoading = true
        
        interactor.fetchCart()
            .tryMap { cart -> Int? in
                return cart?.items.filter { $0.productId == product.id }.first?.id
            }
            .compactMap { $0 }
            .flatMap{ [weak self] (cartItemId: Int) -> AnyPublisher<Bool, Error> in
                guard let self else { return Fail(error: CartError.cartNotFound).eraseToAnyPublisher() }
                return interactor.editItemInCart(itemId: cartItemId, with: quantity)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Editing product quantity failed: \(error.localizedDescription)"
                    self.buttonQuantity = nil
                    
                }
            } receiveValue: { [weak self] success in
                guard let self else { return }
                if success {
                    self.initialQuantity = newQuantity
                    self.quantity = newQuantity
                    self.buttonQuantity = newQuantity
                }
            }
            .store(in: &cancellables)
    }
    
    private func addProdtuctToCart(_ product: ProductDetailPresentationModel) {
        isLoading = true
        interactor.addProductToCart(with: product.id, and: quantity)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Adding product to Cart failed: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                if response.created {
                    self.buttonQuantity = quantity
                    self.initialQuantity = quantity
                    self.saveProductToCart(productId: product.id, itemId: response.itemId, quantity: quantity)
                }
            }
            .store(in: &cancellables)
    }
    
}

//TODO: Make this the interactor's job
extension AddToCartViewPresenter {
    private func saveProductToCart(productId: Int,itemId: Int, quantity: Int) {
        let productList = interactor.retrieveProducts()
        
        guard productList.count > 0 else { return }
        
        guard let product = productList.filter ({ $0.id  == productId }).first else { return }
        
        let cartItem = CartItemPresentationModel(id: itemId, productId: productId, quantity: quantity, product: product)
        
        interactor.saveItemToCart(cartItem: cartItem)
    }
}
