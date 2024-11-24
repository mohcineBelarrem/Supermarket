//
//  OrderItemView.swift
//  Supermarket
//
//  Created by Mohcine on 22/11/2024.
//

import SwiftUI


struct OrderItemView: View {
    @StateObject var presenter: OrderItemPresenter
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Order Id:")
                Text(presenter.orderId)
            }
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.leading)
            Spacer()
            HStack() {
                Text("Order Date:")
                Text(presenter.creationDate)
            }
            .font(.system(size: 14, weight: .semibold))
            Spacer()
            if presenter.isExpanded {
                HStack() {
                    Text("Total price for the order:")
                    Text(presenter.totalOrderPrice)
                }
                .font(.system(size: 14, weight: .semibold))
            }
        }
        .onTapGesture {
            presenter.isExpanded.toggle()
        }
    }
}

