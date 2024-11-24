//
//  OrderItemPresenter.swift
//  Supermarket
//
//  Created by Mohcine on 24/11/2024.
//

import SwiftUI
import Combine

protocol OrderItemPresenterProtocol: ObservableObject {
    var orderId: String { get }
    var creationDate: String { get }
    
    var isExpanded: Bool { get set }
    var totalOrderPrice: String { get }
}


class OrderItemPresenter: OrderItemPresenterProtocol {
    
    private let router: OrderItemRouterProtocol
    private let interactor: OrderItemInteractorProtocol
    
    var item: OrderItemPresentationModel?
    
    var orderId: String {
        item?.orderId ?? "Unknown"
    }
    
    var totalOrderPrice: String {
        guard let item else { return "Unknown" }
        
        let totalPrice: Double = item.items.reduce(0) { $0 + $1.totalPrice }
        
        return totalPrice.formattedPrice
    }
    
    @Published var isExpanded: Bool = false
    
    var creationDate: String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        
        guard let isoDate = item?.created, let date = inputFormatter.date(from: isoDate) else { return "Unknown" }
        
        let humanReadableFormatter = DateFormatter()
        humanReadableFormatter.dateStyle = .medium
        humanReadableFormatter.timeStyle = .short
        humanReadableFormatter.locale = Locale.current
        humanReadableFormatter.dateFormat = "MMM d, yyyy 'at' HH:mm"
        
        return humanReadableFormatter.string(from: date)
    }
    
    init(router: OrderItemRouterProtocol, interactor: OrderItemInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
}
