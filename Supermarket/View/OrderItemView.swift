//
//  OrderItemView.swift
//  Supermarket
//
//  Created by Mohcine on 22/11/2024.
//

import SwiftUI


struct OrderItemView: View {
    var item: OrderItem
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Order Id:")
                Text(item.orderId)
            }
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.leading)
            Spacer()
            HStack() {
                Text("Order Date:")
                Text(item.created)
            }
            .font(.system(size: 14, weight: .semibold))
        }
    }
}

