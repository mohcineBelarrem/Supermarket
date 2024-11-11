//
//  CartService.swift
//  Supermarket
//
//  Created by Mohcine on 10/11/2024.
//

import Foundation
import SwiftData

protocol CartServiceProtocol {
    func fetchCart() -> CartPresentationModel?
    func saveCart(_ cart: CartPresentationModel)
    func deleteCart()
//    func addItem(with id: String, and items: [CartItemPresentationModel])
//    func deleteItem(with id: String, and items: [CartItemPresentationModel])
}

class CartService: CartServiceProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    
    func fetchCart() -> CartPresentationModel? {
        let predicate = #Predicate<CartPresentationModel> { _ in true }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        let result = try? modelContext.fetch(descriptor)
        return result?.first
    }
    
    func saveCart(_ cart: CartPresentationModel) {
        if let oldCart = fetchCart() {
            oldCart.items = cart.items
            oldCart.cartId = cart.cartId
            do {
                try modelContext.save()
            } catch {
                print("Couldn't save cart")
            }
        } else {
            modelContext.insert(cart)
        }
    }
    
    func deleteCart() {
        if let cart = fetchCart() {
            modelContext.delete(cart)
        }
    }
}
