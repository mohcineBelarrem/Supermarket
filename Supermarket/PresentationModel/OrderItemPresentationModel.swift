//
//  OrderItemPresentationModel.swift
//  Supermarket
//
//  Created by Mohcine on 24/11/2024.
//

import SwiftData

@Model
class OrderItemPresentationModel {
    var orderId: String
    var items: [CartItemPresentationModel]
    var created: String
    
    
    init(orderId: String, items: [CartItemPresentationModel], created: String) {
        self.orderId = orderId
        self.items = items
        self.created = created
    }
}
