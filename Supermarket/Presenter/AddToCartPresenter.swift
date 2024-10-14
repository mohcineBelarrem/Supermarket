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
}


class AddToCartPresenter: AddToCartPresenterProtocol {
    private let interactor: AddToCartInteractorProtocol
    private let router: AddToCartRouterProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var errorMessage: String?
    
    init(interactor: AddToCartInteractorProtocol, router: AddToCartRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
}
