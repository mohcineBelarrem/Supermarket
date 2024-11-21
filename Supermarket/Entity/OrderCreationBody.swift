//
//  OrderCreationBody.swift
//  Supermarket
//
//  Created by Mohcine on 21/11/2024.
//

import Foundation

struct OrderCreationBody: Encodable {
    let cartId: String
    let customerName: String
}
