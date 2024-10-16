//
//  AddToCartInteractor.swift
//  Supermarket
//
//  Created by Mohcine on 16/10/2024.
//

import Combine
import Foundation

protocol AddToCartInteractorProtocol {
}

class AddToCartInteractor: AddToCartInteractorProtocol {
    
    private let cartInteractor: CartInteractorProtocol
    
    init(cartInteractor: CartInteractorProtocol) {
        self.cartInteractor = cartInteractor
    }
}
